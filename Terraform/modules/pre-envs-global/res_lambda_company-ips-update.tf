resource "aws_sns_topic_subscription" "ipwl_update" {
  topic_arn = "arn:aws:sns:us-east-1:933806036560:ipwl_update"
  protocol  = "lambda"
  endpoint  = aws_lambda_function.company-ips-change.arn
}

/* resource "aws_sns_topic_subscription" "ipwl_update2" {
  topic_arn = "arn:aws:sns:us-east-1:933806036560:ipwl_update"
  protocol  = "email"
  endpoint  = "Andrey_asoskov@external.company.com"
} */

// S3
data "archive_file" "company-ips-change_py" {
  type        = "zip"
  source_file = "${path.module}/Lambdas/company-ips-change/company-ips-change.py"
  output_path = "${path.module}/Lambdas/company-ips-change.zip"
}

resource "aws_s3_object" "company-ips-change_zip" {
  bucket      = aws_s3_bucket.code_bucket.id
  key         = "Lambdas/company-ips-change.zip"
  source      = data.archive_file.company-ips-change_py.output_path
  source_hash = filemd5("${path.module}/Lambdas/company-ips-change/company-ips-change.py")

  tags = {
    Name = "${var.solution_short}-company-ips-change.zip"
  }
}

//IAM
data "aws_iam_policy_document" "company-ips-change" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "company-ips-change" {
  name               = "${var.solution_short}-company-ips-change"
  assume_role_policy = data.aws_iam_policy_document.company-ips-change.json

  tags = {
    Name = "${var.solution_short}-company-ips-change"
  }
}

data "aws_iam_policy_document" "company-ips-change_premissions" {
  statement {
    sid    = "sns"
    effect = "Allow"
    actions = [
      "sns:*"
    ]
    resources = ["arn:aws:sns:us-east-1:933806036560:ipwl_update"]
  }

  statement {
    sid    = "s3"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = ["arn:aws:s3:::ndm-repo-shared-data/external-ips/offices-and-vpn/company-external-ips.json"]
  }

  statement {
    sid    = "waf1"
    effect = "Allow"
    actions = [
      "wafv2:ListIPSets"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "waf2"
    effect = "Allow"
    actions = [
      "wafv2:UpdateIPSet"
    ]
    resources = [aws_wafv2_ip_set.company-External-IPs.arn]
  }
}

resource "aws_iam_policy" "company-ips-change_premissions" {
  name        = "${var.solution_short}-company-ips-change_premissions"
  path        = "/${var.solution_short}/"
  description = "Permission policy for Lambda(company-ips-change) - ${var.solution}"
  policy      = data.aws_iam_policy_document.company-ips-change_premissions.json

  tags = {
    Name = "${var.solution_short}-company-ips-change_premissions"
  }
}

resource "aws_iam_role_policy_attachment" "company-ips-change_lambda1" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.company-ips-change.name
}

resource "aws_iam_role_policy_attachment" "company-ips-change_lambda2" {
  policy_arn = aws_iam_policy.company-ips-change_premissions.arn
  role       = aws_iam_role.company-ips-change.name
}

// Lambda
resource "aws_lambda_function" "company-ips-change" {
  function_name                  = "${var.solution_short}-company-ips-change"
  s3_bucket                      = aws_s3_object.company-ips-change_zip.bucket
  s3_key                         = aws_s3_object.company-ips-change_zip.key
  source_code_hash               = data.archive_file.company-ips-change_py.output_base64sha256
  role                           = aws_iam_role.company-ips-change.arn
  handler                        = "company-ips-change.handler"
  architectures                  = ["x86_64"]
  runtime                        = "python3.9"
  memory_size                    = "128"
  timeout                        = "180"
  reserved_concurrent_executions = "-1"
  environment {
    variables = {
      waf_ip_set_name  = aws_wafv2_ip_set.company-External-IPs.name
      waf_ip_set_scope = "CLOUDFRONT"
    }
  }

  tags = {
    Name = "${var.solution_short}-company-ips-change"
  }

  depends_on = [
    aws_iam_role_policy_attachment.company-ips-change_lambda1,
    aws_cloudwatch_log_group.company-ips-change
  ]
}

resource "aws_lambda_permission" "company-ips-change" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.company-ips-change.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = "arn:aws:sns:us-east-1:933806036560:ipwl_update"
}

// CloudWatch
resource "aws_cloudwatch_log_group" "company-ips-change" {
  #checkov:skip=CKV_AWS_158:Ensure that CloudWatch Log Group is encrypted by KMS
  name              = "/aws/lambda/${var.solution_short}-copany-ips-change"
  retention_in_days = 14
  #kms_key_id        = aws_kms_alias.global-key-alias.id

  tags = {
    Name = "${var.solution_short}-/aws/lambda/company-ips-change"
  }
}

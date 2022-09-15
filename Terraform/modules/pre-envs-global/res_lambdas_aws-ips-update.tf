resource "aws_sns_topic_subscription" "aws-ips-update_CLOUDFRONT" {
  topic_arn = "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
  protocol  = "lambda"
  endpoint  = aws_lambda_function.aws-ips-update_CLOUDFRONT.arn
}

resource "aws_sns_topic_subscription" "aws-ips-update_REGIONAL" {
  topic_arn = "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
  protocol  = "lambda"
  endpoint  = aws_lambda_function.aws-ips-update_REGIONAL.arn
}

/* resource "aws_sns_topic_subscription" "aws_ips_update2" {
  topic_arn = "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
  protocol  = "email"
  endpoint  = "Andrey_asoskov@external.company.com"
} */

// S3
data "archive_file" "aws-ips-update_CLOUDFRONT_py" {
  type        = "zip"
  source_dir  = "${path.module}/Lambdas/aws-ips-update_CLOUDFRONT/python_packages"
  output_path = "${path.module}/Lambdas/aws-ips-update_CLOUDFRONT.zip"
}

resource "aws_s3_object" "aws-ips-update_CLOUDFRONT_zip" {
  bucket      = aws_s3_bucket.code_bucket.id
  key         = "Lambdas/aws-ips-update_CLOUDFRONT.zip"
  source      = data.archive_file.aws-ips-update_CLOUDFRONT_py.output_path
  source_hash = data.archive_file.aws-ips-update_CLOUDFRONT_py.output_base64sha256
  #source_hash = filemd5("${path.module}/Lambdas/aws_ips_update/aws_ips_update.py")

  tags = {
    Name = "${var.solution_short}-aws-ips-update_CLOUDFRONT.zip"
  }
}

data "archive_file" "aws-ips-update_REGIONAL_py" {
  type        = "zip"
  source_dir  = "${path.module}/Lambdas/aws-ips-update_REGIONAL/python_packages"
  output_path = "${path.module}/Lambdas/aws-ips-update_REGIONAL.zip"
}

resource "aws_s3_object" "aws-ips-update_REGIONAL_zip" {
  bucket      = aws_s3_bucket.code_bucket.id
  key         = "Lambdas/aws-ips-update_REGIONAL.zip"
  source      = data.archive_file.aws-ips-update_REGIONAL_py.output_path
  source_hash = data.archive_file.aws-ips-update_REGIONAL_py.output_base64sha256
  #source_hash = filemd5("${path.module}/Lambdas/aws_ips_update_CF/python_packages/aws_ips_update_CF.py")

  tags = {
    Name = "${var.solution_short}-aws-ips-update_REGIONAL.zip"
  }
}

//IAM
data "aws_iam_policy_document" "aws_ips_update_lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "aws_ips_update_lambda" {
  name               = "${var.solution_short}-aws_ips_update_lambda"
  assume_role_policy = data.aws_iam_policy_document.aws_ips_update_lambda.json

  tags = {
    Name = "${var.solution_short}-aws_ips_update_lambda"
  }
}

data "aws_iam_policy_document" "aws_ips_update_lambda_permissions" {
  #checkov:skip=CKV_AWS_111:Ensure IAM policies does not allow write access without constraints
  statement {
    sid    = "sns"
    effect = "Allow"
    actions = [
      "sns:*"
    ]
    resources = ["arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"]
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
    resources = ["*"]
  }
}

resource "aws_iam_policy" "aws_ips_update_lambda_permissions" {
  name        = "${var.solution_short}-aws_ips_update_lambda_permissions"
  path        = "/${var.solution_short}/"
  description = "Permission Policy for Lambdas (aws_ips_update_*) - ${var.solution}"
  policy      = data.aws_iam_policy_document.aws_ips_update_lambda_permissions.json

  tags = {
    Name = "${var.solution_short}-aws_ips_update_lambda_permissions"
  }
}

resource "aws_iam_role_policy_attachment" "aws_ips_update_lambda1" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.aws_ips_update_lambda.name
}

resource "aws_iam_role_policy_attachment" "aws_ips_update_lambda2" {
  policy_arn = aws_iam_policy.aws_ips_update_lambda_permissions.arn
  role       = aws_iam_role.aws_ips_update_lambda.name
}

// Lambda
resource "aws_lambda_function" "aws-ips-update_CLOUDFRONT" {
  function_name                  = "${var.solution_short}-aws-ips-update_CLOUDFRONT"
  s3_bucket                      = aws_s3_object.aws-ips-update_CLOUDFRONT_zip.bucket
  s3_key                         = aws_s3_object.aws-ips-update_CLOUDFRONT_zip.key
  source_code_hash               = data.archive_file.aws-ips-update_CLOUDFRONT_py.output_base64sha256
  role                           = aws_iam_role.aws_ips_update_lambda.arn
  handler                        = "aws-ips-update_CLOUDFRONT.handler"
  architectures                  = ["x86_64"]
  runtime                        = "python3.9"
  memory_size                    = "128"
  timeout                        = "180"
  reserved_concurrent_executions = "-1"
  environment {
    variables = {
      waf_ip_set_name  = aws_wafv2_ip_set.AWS-R53-HealthCheck-IP-ranges.name
      waf_ip_set_scope = "CLOUDFRONT"
    }
  }

  tags = {
    Name = "${var.solution_short}-aws-ips-update_CLOUDFRONT"
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_ips_update_lambda1,
    aws_cloudwatch_log_group.aws-ips-update_CLOUDFRONT
  ]
}

resource "aws_lambda_permission" "aws-ips-update_CLOUDFRONT" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws-ips-update_CLOUDFRONT.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
}

resource "aws_lambda_function" "aws-ips-update_REGIONAL" {
  function_name                  = "${var.solution_short}-aws-ips-update_REGIONAL"
  s3_bucket                      = aws_s3_object.aws-ips-update_REGIONAL_zip.bucket
  s3_key                         = aws_s3_object.aws-ips-update_REGIONAL_zip.key
  source_code_hash               = data.archive_file.aws-ips-update_REGIONAL_py.output_base64sha256
  role                           = aws_iam_role.aws_ips_update_lambda.arn
  handler                        = "aws-ips-update_REGIONAL.handler"
  architectures                  = ["x86_64"]
  runtime                        = "python3.9"
  memory_size                    = "128"
  timeout                        = "180"
  reserved_concurrent_executions = "-1"
  environment {
    variables = {
      waf_ip_set_name  = "AWS-CloudFront-IP-ranges"
      waf_ip_set_scope = "REGIONAL"
      aws_regions      = join(",", var.aws_regions)
    }
  }

  tags = {
    Name = "${var.solution_short}-aws-ips-update_REGIONAL"
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_ips_update_lambda1,
    aws_cloudwatch_log_group.aws-ips-update_REGIONAL
  ]
}

resource "aws_lambda_permission" "aws-ips-update_REGIONAL" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws-ips-update_REGIONAL.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
}

// CloudWatch
resource "aws_cloudwatch_log_group" "aws-ips-update_CLOUDFRONT" {
  #checkov:skip=CKV_AWS_158:Ensure that CloudWatch Log Group is encrypted by KMS
  name              = "/aws/lambda/${var.solution_short}-aws-ips-update_CLOUDFRONT"
  retention_in_days = 14
  #kms_key_id        = aws_kms_alias.global-key-alias.id

  tags = {
    Name = "${var.solution_short}-/aws/lambda/aws-ips-update_CLOUDFRONT"
  }
}

resource "aws_cloudwatch_log_group" "aws-ips-update_REGIONAL" {
  #checkov:skip=CKV_AWS_158:Ensure that CloudWatch Log Group is encrypted by KMS
  name              = "/aws/lambda/${var.solution_short}-aws-ips-update_REGIONAL"
  retention_in_days = 14
  #kms_key_id        = aws_kms_alias.global-key-alias.id

  tags = {
    Name = "${var.solution_short}-/aws/lambda/aws-ips-update_REGIONAL"
  }
}

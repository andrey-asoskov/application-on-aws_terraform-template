data "aws_iam_policy_document" "env_stop_start_lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "env_stop_start_lambda" {
  name               = "${var.solution_short}-env_stop_start_lambda"
  assume_role_policy = data.aws_iam_policy_document.env_stop_start_lambda.json

  tags = {
    Name = "${var.solution_short}-env_stop_start_lambda"
  }
}

resource "aws_iam_role_policy_attachment" "env_stop_start_lambda1" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.env_stop_start_lambda.name
}

resource "aws_iam_role_policy_attachment" "env_stop_start_lambda2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.env_stop_start_lambda.name
}

resource "aws_iam_role_policy_attachment" "env_stop_start_lambda3" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.env_stop_start_lambda.name
}

resource "aws_iam_role_policy_attachment" "env_stop_start_lambda4" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  role       = aws_iam_role.env_stop_start_lambda.name
}

data "archive_file" "env_stop_py" {
  type        = "zip"
  source_file = "${path.module}/Lambdas/env_stop/env_stop.py"
  output_path = "${path.module}/Lambdas/env_stop.zip"
}

resource "aws_s3_object" "env_stop_zip" {
  bucket      = aws_s3_bucket.code_bucket.id
  key         = "Lambdas/env_stop.zip"
  source      = data.archive_file.env_stop_py.output_path
  source_hash = filemd5("${path.module}/Lambdas/env_stop/env_stop.py")

  tags = {
    Name = "${var.solution_short}-env_stop.zip"
  }
}

data "archive_file" "env_start_py" {
  type        = "zip"
  source_file = "${path.module}/Lambdas/env_start/env_start.py"
  output_path = "${path.module}/Lambdas/env_start.zip"
}

resource "aws_s3_object" "env_start_zip" {
  bucket      = aws_s3_bucket.code_bucket.id
  key         = "Lambdas/env_start.zip"
  source      = data.archive_file.env_start_py.output_path
  source_hash = filemd5("${path.module}/Lambdas/env_start/env_start.py")

  tags = {
    Name = "${var.solution_short}-env_start.zip"
  }
}

resource "aws_lambda_function" "env_stop" {
  function_name    = "${var.solution_short}-env_stop_lambda"
  s3_bucket        = aws_s3_object.env_stop_zip.bucket
  s3_key           = aws_s3_object.env_stop_zip.key
  source_code_hash = data.archive_file.env_stop_py.output_base64sha256
  #source_code_hash = filemd5("${path.module}/Lambdas/env_stop.py")
  role                           = aws_iam_role.env_stop_start_lambda.arn
  handler                        = "env_stop.shut_off"
  architectures                  = ["x86_64"]
  runtime                        = "python3.9"
  memory_size                    = "128"
  timeout                        = "180"
  reserved_concurrent_executions = "-1"

  tags = {
    Name = "${var.solution_short}-env_stop_lambda"
  }

  depends_on = [
    aws_iam_role_policy_attachment.env_stop_start_lambda1,
    aws_cloudwatch_log_group.env_stop_lambda,
  ]
}

resource "aws_lambda_permission" "env_stop" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.env_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.env_stop.arn
}

resource "aws_lambda_function" "env_start" {
  function_name    = "${var.solution_short}-env_start_lambda"
  s3_bucket        = aws_s3_object.env_start_zip.bucket
  s3_key           = aws_s3_object.env_start_zip.key
  source_code_hash = data.archive_file.env_start_py.output_base64sha256
  #source_code_hash = filemd5("${path.module}/Lambdas/env_start.py")
  role                           = aws_iam_role.env_stop_start_lambda.arn
  handler                        = "env_start.turn_on"
  architectures                  = ["x86_64"]
  runtime                        = "python3.9"
  memory_size                    = "128"
  timeout                        = "180"
  reserved_concurrent_executions = "-1"

  tags = {
    Name = "${var.solution_short}-env_start_lambda"
  }

  depends_on = [
    aws_iam_role_policy_attachment.env_stop_start_lambda1,
    aws_cloudwatch_log_group.env_start_lambda,
  ]
}

resource "aws_cloudwatch_log_group" "env_stop_lambda" {
  #checkov:skip=CKV_AWS_158:Ensure that CloudWatch Log Group is encrypted by KMS
  name              = "/aws/lambda/${var.solution_short}-env_stop_lambda"
  retention_in_days = 14
  #kms_key_id        = aws_kms_alias.global-key-alias.id

  tags = {
    Name = "${var.solution_short}-/aws/lambda/env_stop"
  }
}

resource "aws_cloudwatch_event_rule" "env_stop" {
  name                = "StopEnv"
  description         = "Stop env nightly"
  schedule_expression = "cron(0 0 * * ? *)" #UTC
  #schedule_expression = "cron(20 12 * * ? *)" #UTC #For tests

  tags = {
    Name = "${var.solution_short}-StopEnv"
  }
}

resource "aws_cloudwatch_event_target" "env_stop" {
  rule = aws_cloudwatch_event_rule.env_stop.name
  arn  = aws_lambda_function.env_stop.arn
}

resource "aws_cloudwatch_log_group" "env_start_lambda" {
  #checkov:skip=CKV_AWS_158:Ensure that CloudWatch Log Group is encrypted by KMS
  name              = "/aws/lambda/${var.solution_short}-env_start_lambda"
  retention_in_days = 14
  #kms_key_id        = aws_kms_alias.global-key-alias.id

  tags = {
    Name = "${var.solution_short}-/aws/lambda/env_start"
  }
}

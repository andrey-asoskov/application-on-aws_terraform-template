data "aws_kms_secrets" "new_relic_api_key" {
  secret {
    name    = "new_relic_api_key"
    payload = var.new_relic_api_key_ciphertext
  }
}

// S3 bucket for Kinesis buffer
data "aws_iam_policy_document" "kinesis-buffer" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.kinesis-buffer.arn,
      "${aws_s3_bucket.kinesis-buffer.arn}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "kinesis-buffer" {
  bucket = aws_s3_bucket.kinesis-buffer.id
  policy = data.aws_iam_policy_document.kinesis-buffer.json
}

resource "aws_s3_bucket" "kinesis-buffer" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${var.solution_short}-kinesis-buffer"
  force_destroy = true

  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${var.solution_short}-kinesis-buffer"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kinesis-buffer" {
  bucket = aws_s3_bucket.kinesis-buffer.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_alias.region-key-alias.id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "kinesis-buffer" {
  bucket = aws_s3_bucket.kinesis-buffer.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "kinesis-buffer" {
  bucket                  = aws_s3_bucket.kinesis-buffer.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "kinesis-buffer" {
  bucket = aws_s3_bucket.kinesis-buffer.id

  rule {
    id     = "logs"
    status = "Enabled"

    expiration {
      days = 90
    }
  }
}

resource "aws_cloudwatch_log_group" "new-relic" {
  name              = "/aws/kinesisfirehose/${var.solution_short}-new-relic"
  kms_key_id        = aws_kms_alias.region-key-alias.arn
  retention_in_days = 90

  tags = {
    Name = "/aws/kinesisfirehose/${var.solution_short}-new-relic"
  }
}

resource "aws_cloudwatch_log_stream" "new-relic" {
  name           = "new-relic"
  log_group_name = aws_cloudwatch_log_group.new-relic.name
}

resource "aws_cloudwatch_log_stream" "new-relic-s3" {
  name           = "new-relic-s3"
  log_group_name = aws_cloudwatch_log_group.new-relic.name
}

// Kinesis stream

resource "aws_kinesis_firehose_delivery_stream" "new-relic" {
  name        = "${var.solution_short}-new-relic"
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = aws_iam_role.kinesis.arn
    bucket_arn         = aws_s3_bucket.kinesis-buffer.arn
    buffer_size        = 1
    buffer_interval    = 60
    compression_format = "GZIP"
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.new-relic.name
      log_stream_name = aws_cloudwatch_log_stream.new-relic-s3.name
    }
  }

  http_endpoint_configuration {
    url                = "https://aws-api.newrelic.com/cloudwatch-metrics/v1"
    name               = "New Relic"
    access_key         = data.aws_kms_secrets.new_relic_api_key.plaintext["new_relic_api_key"]
    buffering_size     = 1
    buffering_interval = 60
    retry_duration     = 60
    role_arn           = aws_iam_role.kinesis.arn
    s3_backup_mode     = "FailedDataOnly"

    request_configuration {
      content_encoding = "GZIP"
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.new-relic.name
      log_stream_name = aws_cloudwatch_log_stream.new-relic.name
    }
  }

  tags = {
    Name = "${var.solution_short}-new-relic"
  }
}

resource "aws_cloudwatch_metric_stream" "new-relic" {
  name          = "${var.solution_short}-new-relic"
  role_arn      = aws_iam_role.cw-metric-stream.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.new-relic.arn
  output_format = "opentelemetry0.7"

  include_filter {
    namespace = "AWS/EC2"
  }

  tags = {
    Name = "${var.solution_short}-new-relic"
  }
}

// Role for Kinesis

data "aws_iam_policy_document" "kinesis" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "kinesis-rights" {
  statement {
    effect = "Allow"
    sid    = "s3bucket"
    actions = [
      "s3:ListBucketMultipartUploads",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      aws_s3_bucket.kinesis-buffer.arn
    ]
  }

  statement {
    effect = "Allow"
    sid    = "s3objects"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUploads"
    ]

    resources = [
      "${aws_s3_bucket.kinesis-buffer.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    sid    = "kms"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      #"arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/${aws_kms_key.region-key.id}"
      aws_kms_key.region-key.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"

      values = [
        "s3.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"

      values = [
        "${aws_s3_bucket.kinesis-buffer.arn}/*"
      ]
    }
  }

  statement {
    effect = "Allow"
    sid    = "kinesis"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards"
    ]

    resources = [
      "arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/new-relic"
    ]
  }

  statement {
    effect = "Allow"
    sid    = "logs"
    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.new-relic.name}:log-stream:*"
    ]
  }
}

resource "aws_iam_policy" "kinesis-rights" {
  name        = "${var.solution_short}-${data.aws_region.current.name}-kinesis-rights"
  path        = "/${var.solution_short}/"
  description = "Policy for Kinesis to access and send data - ${var.solution}"
  policy      = data.aws_iam_policy_document.kinesis-rights.json

  tags = {
    Name = "${var.solution_short}-${data.aws_region.current.name}-kinesis-rights"
  }
}

resource "aws_iam_role" "kinesis" {
  name               = "${var.solution_short}-${data.aws_region.current.name}-kinesis"
  assume_role_policy = data.aws_iam_policy_document.kinesis.json

  tags = {
    Name = "${var.solution_short}-${data.aws_region.current.name}-kinesis"
  }
}

resource "aws_iam_role_policy_attachment" "kinesis_1" {
  role       = aws_iam_role.kinesis.name
  policy_arn = aws_iam_policy.kinesis-rights.arn
}

// Role for CloudWatch metric stream

data "aws_iam_policy_document" "cw-metric-stream" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cw-metric-stream-rights" {
  statement {
    effect = "Allow"
    sid    = "firehose"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]

    resources = [
      aws_kinesis_firehose_delivery_stream.new-relic.arn
    ]
  }
}

resource "aws_iam_policy" "cw-metric-stream-rights" {
  name        = "${var.solution_short}-${data.aws_region.current.name}-cw-metric-stream-rights"
  path        = "/${var.solution_short}/"
  description = "Policy for CloudWatch to send data to Kinesis - ${var.solution}-${data.aws_region.current.name}"
  policy      = data.aws_iam_policy_document.cw-metric-stream-rights.json

  tags = {
    Name = "${var.solution_short}-${data.aws_region.current.name}-cw-metric-stream-rights"
  }
}

resource "aws_iam_role" "cw-metric-stream" {
  name               = "${var.solution_short}-${data.aws_region.current.name}-cw-metric-stream"
  assume_role_policy = data.aws_iam_policy_document.cw-metric-stream.json

  tags = {
    Name = "${var.solution_short}-${data.aws_region.current.name}-cw-metric-stream"
  }
}

resource "aws_iam_role_policy_attachment" "cw-metric-stream_1" {
  role       = aws_iam_role.cw-metric-stream.name
  policy_arn = aws_iam_policy.cw-metric-stream-rights.arn
}

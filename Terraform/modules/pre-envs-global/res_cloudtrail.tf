data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "cloudtrail-s3-bucket" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      aws_s3_bucket.cloudtrail.arn
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.cloudtrail.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.cloudtrail.arn,
      "${aws_s3_bucket.cloudtrail.arn}/*",
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

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${var.solution_short}-cloudtrail"
  force_destroy = true

  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.solution_short}-cloudtrail"
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail-s3-bucket.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_alias.global-key-alias.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    id     = "logs"
    status = "Enabled"

    expiration {
      days = 90
    }
  }
}

resource "aws_cloudtrail" "trail" {
  name                          = var.solution_short
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  s3_key_prefix                 = var.solution_short
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_alias.global-key-alias.target_key_arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn

  tags = {
    Name = var.solution_short
  }
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "${var.solution_short}-cloudtrail"
  kms_key_id        = aws_kms_alias.global-key-alias.arn
  retention_in_days = 90

  tags = {
    Name = "${var.solution_short}-cloudtrail"
  }
}

resource "aws_cloudwatch_log_stream" "cloudtrail" {
  name           = "${var.solution_short}-cloudtrail"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cwl_policy" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    sid     = "1"
    actions = ["logs:CreateLogStream"]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail.name}:log-stream:*",
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["logs:PutLogEvents"]
    sid     = "2"

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail.name}:log-stream:*",
    ]
  }
}

resource "aws_iam_policy" "PutCloudWatchLogs" {
  name        = "${var.solution_short}-PutCloudWatchLogs"
  path        = "/${var.solution_short}/"
  description = "Policy to upload CloudWatch Logs for CloudTrail - ${var.solution}"
  policy      = data.aws_iam_policy_document.cwl_policy.json

  tags = {
    Name = "${var.solution_short}-PutCloudWatchLogs"
  }
}

resource "aws_iam_role" "cloudtrail_role" {
  name               = "${var.solution_short}-cloudtrail"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail.json

  tags = {
    Name = "${var.solution_short}-cloudtrail"
  }
}

resource "aws_iam_role_policy_attachment" "cloudtrail_role1" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.cloudtrail_role.name
}

resource "aws_iam_role_policy_attachment" "cloudtrail_role2" {
  policy_arn = aws_iam_policy.PutCloudWatchLogs.arn
  role       = aws_iam_role.cloudtrail_role.name
}

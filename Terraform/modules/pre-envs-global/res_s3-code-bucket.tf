data "aws_iam_policy_document" "code_bucket" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.code_bucket.arn,
      "${aws_s3_bucket.code_bucket.arn}/*",
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

resource "aws_s3_bucket" "code_bucket" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${var.solution_short}-code-bucket"
  force_destroy = true

  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.solution_short}-code-bucket"
  }
}

resource "aws_s3_bucket_policy" "code_bucket" {
  bucket = aws_s3_bucket.code_bucket.id
  policy = data.aws_iam_policy_document.code_bucket.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "code_bucket" {
  bucket = aws_s3_bucket.code_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_alias.global-key-alias.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "code_bucket" {
  bucket = aws_s3_bucket.code_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "code_bucket" {
  bucket                  = aws_s3_bucket.code_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "GetFilesFromCodeBucket" {
  statement {
    sid     = "S3Bucket"
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      aws_s3_bucket.code_bucket.arn
    ]
  }

  statement {
    sid     = "S3Object"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.code_bucket.arn}/*"
    ]
  }

  statement {
    sid    = "Decrypt"
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:Decrypt"
    ]
    resources = [
      aws_kms_key.global-key.arn
    ]
  }
}

resource "aws_iam_policy" "AppGetFilesFromCodeBucket" {
  name        = "${var.solution_short}-GetFilesFromCodeBucket"
  path        = "/${var.solution_short}/"
  description = "Policy to download files from code bucket for - ${var.solution}"
  policy      = data.aws_iam_policy_document.GetFilesFromCodeBucket.json

  tags = {
    Name = "${var.solution_short}-GetFilesFromCodeBucket"
  }
}

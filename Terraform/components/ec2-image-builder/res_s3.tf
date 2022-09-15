data "archive_file" "ansible" {
  type        = "zip"
  source_dir  = "${path.cwd}/Ansible"
  output_path = "${path.cwd}/Ansible/ansible.zip"
}

data "aws_iam_policy_document" "ec2ib_bucket" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.ec2ib_bucket.arn,
      "${aws_s3_bucket.ec2ib_bucket.arn}/*",
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

resource "aws_s3_bucket" "ec2ib_bucket" {
  bucket        = local.s3_ec2_ib_bucket_name
  force_destroy = true

  tags = {
    Name = local.s3_ec2_ib_bucket_name
  }
}

resource "aws_s3_bucket_policy" "ec2ib_bucket" {
  bucket = aws_s3_bucket.ec2ib_bucket.id
  policy = data.aws_iam_policy_document.ec2ib_bucket.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ec2ib_bucket" {
  bucket = aws_s3_bucket.ec2ib_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.terraform_remote_state.VPC.outputs.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "ec2ib_bucket" {
  bucket = aws_s3_bucket.ec2ib_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "ec2ib_bucket" {
  bucket = aws_s3_bucket.ec2ib_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "ec2ib_bucket" {
  bucket = aws_s3_bucket.ec2ib_bucket.id

  rule {
    id     = "logs"
    status = "Enabled"

    expiration {
      days = 90
    }
  }
}

resource "aws_s3_object" "ansible" {
  bucket      = aws_s3_bucket.ec2ib_bucket.id
  key         = "ansible.zip"
  source      = data.archive_file.ansible.output_path
  source_hash = filemd5(data.archive_file.ansible.output_path)

  tags = {
    Name = "ansible"
  }
}

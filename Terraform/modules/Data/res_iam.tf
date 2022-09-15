data "aws_iam_policy_document" "GetFilesFromStorageBucket" {
  statement {
    effect = "Allow"
    sid    = "s3buckets"
    actions = [
      "s3:ListBucketMultipartUploads",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.storage.id}"
    ]
  }

  statement {
    effect = "Allow"
    sid    = "s3objects"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.storage.id}/*"
    ]
  }
}

resource "aws_iam_policy" "AppCoreGetFilesFromStorageBucket" {
  name        = "${var.solution}-${var.env}-GetFilesFromStorageBucket"
  path        = "/"
  description = "Policy to download files from storage bucket for - ${var.solution}-${var.env}"
  policy      = data.aws_iam_policy_document.GetFilesFromStorageBucket.json

  tags = {
    Name = "${var.solution}-${var.env}-GetFilesFromStorageBucket"
  }
}

data "aws_iam_policy_document" "RDS_enhanced_monitoring" {
  statement {
    effect  = "Allow"
    sid     = "monitoring"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "RDS_enhanced_monitoring" {
  name               = "${var.solution}-${var.env}-RDS_enhanced_monitoring"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.RDS_enhanced_monitoring.json

  tags = {
    Name = "${var.solution}-${var.env}-RDS_enhanced_monitoring"
  }
}

resource "aws_iam_role_policy_attachment" "RDS_enhanced_monitoring1" {
  role       = aws_iam_role.RDS_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "GetValuesFromSecretsManager" {
  statement {
    effect = "Allow"
    sid    = "SecretManager1"
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_secretsmanager_secret.secret.id
    ]
  }
}

resource "aws_iam_policy" "GetValuesFromSecretsManager" {
  name        = "${var.solution_short}-${var.env}-GetValuesFromSecretsManager"
  path        = "/"
  description = "Policy to get values from Secrets Manager for - ${var.solution}-${var.env}"
  policy      = data.aws_iam_policy_document.GetValuesFromSecretsManager.json

  tags = {
    Name = "${var.solution_short}-${var.env}-GetValuesFromSecretsManager"
  }
}

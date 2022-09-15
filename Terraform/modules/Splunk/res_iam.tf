data "aws_iam_policy_document" "Splunk" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "Splunk_policy" {
  #checkov:skip=CKV_AWS_108:Ensure IAM policies does not allow data exfiltration
  #checkov:skip=CKV_AWS_111:Ensure IAM policies does not allow write access without constraints
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    sid     = "cloudwatch"
    actions = ["cloudwatch:PutMetricData"]

    resources = ["*"]
  }

  /*  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    sid       = "kms"
    resources = [var.kms_key_arn]
  }*/

  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation"
    ]
    sid       = "ssm"
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    sid       = "ssmmessages"
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply"
    ]
    sid       = "ec2messages"
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ds:CreateComputer",
      "ds:DescribeDirectories"
    ]
    sid       = "ds"
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    sid       = "logs"
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetEncryptionConfiguration",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads"
    ]
    sid       = "s3"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "Splunk_policy" {
  name        = "${var.solution}-${var.env}-Splunk"
  path        = "/${var.solution}/"
  description = "Policy for Splunk - ${var.solution}-${var.env}"
  policy      = data.aws_iam_policy_document.Splunk_policy.json

  tags = merge({
    Name = "${var.solution}-${var.env}-Splunk"
  }, local.common_tags)
}

resource "aws_iam_role" "Splunk" {
  name               = "${var.solution}-${var.env}-Splunk"
  path               = "/${var.solution}/"
  assume_role_policy = data.aws_iam_policy_document.Splunk.json

  tags = merge({
    Name = "${var.solution}-${var.env}-Splunk"
  }, local.common_tags)
}

resource "aws_iam_role_policy_attachment" "Splunk1" {
  role       = aws_iam_role.Splunk.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "Splunk2" {
  role       = aws_iam_role.Splunk.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "Splunk3" {
  role       = aws_iam_role.Splunk.name
  policy_arn = aws_iam_policy.Splunk_policy.arn
}

resource "aws_iam_role_policy_attachment" "Splunk4" {
  role       = aws_iam_role.Splunk.name
  policy_arn = var.Policy_UseKMS_arn
}

resource "aws_iam_instance_profile" "Splunk" {
  name = "${var.solution}-${var.env}-Splunk"
  path = "/${var.solution}/"
  role = aws_iam_role.Splunk.name
}

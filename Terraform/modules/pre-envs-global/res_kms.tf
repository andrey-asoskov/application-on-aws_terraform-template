resource "aws_kms_key" "global-key" {
  description             = "${var.solution}- Global Key for AWS account"
  deletion_window_in_days = (var.aws_account_type == "npn " ? 7 : 10)
  policy                  = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "Enable IAM policies",
          "Effect": "Allow",
          "Principal": {
            "AWS": ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
           },
          "Action": "kms:*",
          "Resource": "*"
        },
        {
          "Sid": "Allow CloudTrail to encrypt logs",
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "kms:GenerateDataKey*",
          "Resource": "*",
          "Condition": {
            "StringLike": {
              "kms:EncryptionContext:aws:cloudtrail:arn": [
                "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
              ]
            }
          }
        },
        {
          "Sid": "Allow CloudTrail access",
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "kms:DescribeKey",
          "Resource": "*"
        },
        {
            "Sid": "Allow encrypt cloudwatch logs",
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${data.aws_region.current.name}.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "*",
            "Condition": {
                "ArnEquals": {
                    "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
                }
            }
        }
    ]
}
POLICY

  tags = {
    Name = "${var.solution_short}-global-key"
  }
}

resource "aws_kms_alias" "global-key-alias" {
  name          = "alias/${var.solution_short}-global"
  target_key_id = aws_kms_key.global-key.key_id
}


data "aws_iam_policy_document" "global-key" {
  statement {
    actions   = ["kms:Encrypt", "kms:Decrypt", "kms:GenerateDataKey", "kms:ReEncrypt*", "kms:DescribeKey"]
    resources = [aws_kms_key.global-key.arn]
  }
}

resource "aws_iam_policy" "global-key" {
  name        = "${var.solution_short}-global-key"
  path        = "/${var.solution_short}/"
  description = "Policy to use Global KMS key - ${var.solution}"
  policy      = data.aws_iam_policy_document.global-key.json

  tags = {
    Name = "${var.solution_short}-global-key"
  }
}

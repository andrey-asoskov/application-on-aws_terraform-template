data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_kms_key" "region-key" {
  description             = "${var.solution}- Region Key for AWS account"
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
    Name = "${var.solution_short}-region-key"
  }
}

resource "aws_kms_alias" "region-key-alias" {
  name          = "alias/${var.solution_short}-region"
  target_key_id = aws_kms_key.region-key.key_id
}

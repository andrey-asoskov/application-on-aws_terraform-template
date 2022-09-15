# Github Actions OIDC provider is used for federated auth and role assumption
# See https://github.com/aws-actions/configure-aws-credentials for the
# configuration details
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

## Can only be declared once so ignore if on STG
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "gha-access-restrict" {
  statement {
    sid       = ""
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["*"]

    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = var.ips_runners
    }

    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = var.ips_tfe
    }
  }
}

resource "aws_iam_policy" "gha-access-restrict" {
  name        = "${var.solution_short}-gha-access-restrict"
  path        = "/${var.solution_short}/"
  description = "IAM policy for ${var.solution} to allow access only from GHA IPs."

  policy = data.aws_iam_policy_document.gha-access-restrict.json
}


// Roles

## ASSUME ROLE POLICIES FOR OIDC
data "aws_iam_policy_document" "assume_role_with_oidc_tf_plan" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "ForAllValues:StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_org}/${var.github_repo}:*"
      ]
    }
  }
}

data "aws_iam_policy_document" "assume_role_with_oidc_tf_apply" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "ForAllValues:StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_org}/${var.github_repo}:*"
      ]
    }
    /*    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_org}/${var.github_repo}:environment:${var.env}",
        "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.env}"
      ]
    }*/
  }
}

data "aws_iam_policy_document" "assume_role_with_oidc_packer_build" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "ForAllValues:StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_org}/${var.github_repo}:*"
      ]
    }
  }
}

## IAM ROLES FOR GH RUNNERS
resource "aws_iam_role" "tf_plan" {
  name                 = "${var.solution_short}-tf-plan"
  max_session_duration = 18000
  description          = "IAM role for ${var.solution} to run TF plan"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_with_oidc_tf_plan.json
}

resource "aws_iam_role" "tf_apply" {
  name                 = "${var.solution_short}-tf-apply"
  max_session_duration = 18000
  description          = "IAM role for ${var.solution} to run TF apply"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_with_oidc_tf_apply.json
}

resource "aws_iam_role" "packer_build" {
  name                 = "${var.solution_short}-packer-build"
  max_session_duration = 18000
  description          = "IAM role for ${var.solution} to run packer build"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_with_oidc_packer_build.json
}

resource "aws_iam_policy_attachment" "gha-access-restrict" {
  name = "${var.solution_short}-gha-access-restrict"
  roles = [
    aws_iam_role.tf_plan.name,
    aws_iam_role.tf_apply.name,
    aws_iam_role.packer_build.name
  ]
  policy_arn = aws_iam_policy.gha-access-restrict.arn
}



## POLICY FOR TF PLAN ROLE
data "aws_iam_policy_document" "tf_plan" {
  #checkov:skip=CKV_AWS_108
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:ListQueues",
      "iam:Get*",
      "iam:List*",
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "tf_plan" {
  name        = "${var.solution_short}-tf-plan"
  path        = "/${var.solution_short}/"
  description = "IAM policy for ${var.solution_short} to run TF plan"
  policy      = data.aws_iam_policy_document.tf_plan.json
}

## POLICY FOR TF APPLY ROLE
data "aws_iam_policy_document" "tf_apply" {
  #checkov:skip=CKV_AWS_109:Ensure IAM policies does not allow permissions management / resource exposure without constraints
  #checkov:skip=CKV_AWS_108:Ensure IAM policies does not allow data exfiltration
  #checkov:skip=CKV_AWS_111:Ensure IAM policies does not allow write access without constraints
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "sqs:*",
      "sns:*",
      "wafv2:*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "tf_apply" {
  name        = "${var.solution_short}-tf-apply"
  path        = "/${var.solution_short}/"
  description = "IAM policy for ${var.solution} to run TF apply"
  policy      = data.aws_iam_policy_document.tf_apply.json
}

data "aws_iam_policy_document" "packer_build" {
  #checkov:skip=CKV_AWS_107:Ensure IAM policies does not allow credentials exposure
  #checkov:skip=CKV_AWS_109:Ensure IAM policies does not allow permissions management / resource exposure without constraints
  #checkov:skip=CKV_AWS_110:Ensure IAM policies does not allow privilege escalation
  #checkov:skip=CKV_AWS_108:Ensure IAM policies does not allow data exfiltration
  #checkov:skip=CKV_AWS_111:Ensure IAM policies does not allow write access without constraints
  statement {
    effect = "Allow"
    actions = [
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateKeypair",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteKeyPair",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSnapshot",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:GetPasswordData",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifySnapshotAttribute",
      "ec2:RegisterImage",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "iam:GetInstanceProfile",
      "iam:PassRole",
      "iam:CreateServiceLinkedRole",
      #"iam:*",
      #"ec2:*",
      "kms:*",
      "ssm:*",
      "ssmmessages:*",
      "sts:*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "packer_build" {
  name        = "${var.solution_short}-packer-build"
  path        = "/${var.solution_short}/"
  description = "IAM policy for ${var.solution} to run packer build"
  policy      = data.aws_iam_policy_document.packer_build.json
}

## IAM ROLE ATTACHEMENTS
## GITHUB ACTIONS RUNNER - PLAN
resource "aws_iam_role_policy_attachment" "tf_plan" {
  role       = aws_iam_role.tf_plan.name
  policy_arn = aws_iam_policy.tf_plan.arn
}

## GITHUB ACTIONS RUNNER - APPLY
resource "aws_iam_role_policy_attachment" "tf_apply" {
  role       = aws_iam_role.tf_apply.name
  policy_arn = aws_iam_policy.tf_apply.arn
}

resource "aws_iam_role_policy_attachment" "packer_build1" {
  role       = aws_iam_role.packer_build.name
  policy_arn = aws_iam_policy.packer_build.arn
}

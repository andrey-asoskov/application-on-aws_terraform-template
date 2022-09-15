// Tenable

data "aws_iam_policy_document" "security" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["718737690008"]
    }
  }
}

resource "aws_iam_role" "security" {
  name               = "cube-security-service"
  description        = "Role is used for MCST(Security-Audit). For questions please contact clientech_ipsec@company.com"
  assume_role_policy = data.aws_iam_policy_document.security.json

  tags = {
    Name = "cube-security-service"
  }
}

resource "aws_iam_role_policy_attachment" "security_role1" {
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  role       = aws_iam_role.security.name
}

// Role for NewRelic
data "aws_iam_policy_document" "new-relic" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["754728514883"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        "3224997"
      ]
    }
  }
}

resource "aws_iam_role" "new-relic" {
  name               = "NewRelicInfrastructure-Integrations"
  assume_role_policy = data.aws_iam_policy_document.new-relic.json

  tags = {
    Name = "${var.solution_short}-new-relic"
  }
}

data "aws_iam_policy_document" "budget" {
  statement {
    effect  = "Allow"
    sid     = "budgets"
    actions = ["budgets:ViewBudget"]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "budget" {
  name        = "${var.solution_short}-NR-budget"
  path        = "/${var.solution_short}/"
  description = "Policy for NR to read AWS budgets - ${var.solution}"
  policy      = data.aws_iam_policy_document.budget.json

  tags = {
    Name = "${var.solution_short}-NR-budget"
  }
}

resource "aws_iam_role_policy_attachment" "new-relic_1" {
  role       = aws_iam_role.new-relic.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "new-relic_2" {
  role       = aws_iam_role.new-relic.name
  policy_arn = aws_iam_policy.budget.arn
}

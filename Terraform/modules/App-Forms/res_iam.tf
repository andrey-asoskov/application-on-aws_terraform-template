data "aws_iam_policy_document" "AppForms" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "AppForms" {
  name               = "${var.solution_short}-${var.env}-AppForms"
  path               = "/${var.solution_short}/"
  assume_role_policy = data.aws_iam_policy_document.AppForms.json

  tags = {
    Name = "${var.solution_short}-${var.env}-AppForms"
  }
}

resource "aws_iam_role_policy_attachment" "AppForms1" {
  role       = aws_iam_role.AppForms.name
  policy_arn = var.Policy_GetFilesFromStorageBucket_arn
}

resource "aws_iam_role_policy_attachment" "AppForms2" {
  role       = aws_iam_role.AppForms.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AppForms3" {
  role       = aws_iam_role.AppForms.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "AppForms4" {
  role       = aws_iam_role.AppForms.name
  policy_arn = var.Policy_UseKMS_arn
}

resource "aws_iam_role_policy_attachment" "AppForms5" {
  role       = aws_iam_role.AppForms.name
  policy_arn = var.Policy_GetValuesFromSecretsManager_arn
}

resource "aws_iam_instance_profile" "AppForms" {
  name = "${var.solution_short}-${var.env}-Forms"
  path = "/${var.solution_short}/"
  role = aws_iam_role.AppForms.name
}

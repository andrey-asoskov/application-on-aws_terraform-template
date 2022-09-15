data "aws_iam_policy_document" "AppTrainer" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "AppTrainer" {
  name               = "${var.solution_short}-${var.env}-AppTrainer"
  path               = "/${var.solution_short}/"
  assume_role_policy = data.aws_iam_policy_document.AppTrainer.json

  tags = {
    Name = "${var.solution_short}-${var.env}-AppTrainer"
  }
}

resource "aws_iam_role_policy_attachment" "AppTrainer1" {
  role       = aws_iam_role.AppTrainer.name
  policy_arn = var.Policy_AppCoreGetFilesFromStorageBucket_arn
}

resource "aws_iam_role_policy_attachment" "AppTrainer2" {
  role       = aws_iam_role.AppTrainer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AppTrainer3" {
  role       = aws_iam_role.AppTrainer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "AppTrainer4" {
  role       = aws_iam_role.AppTrainer.name
  policy_arn = var.Policy_UseKMS_arn
}

resource "aws_iam_instance_profile" "AppTrainer" {
  name = "${var.solution_short}-${var.env}-Trainer"
  path = "/${var.solution_short}/"
  role = aws_iam_role.AppTrainer.name
}

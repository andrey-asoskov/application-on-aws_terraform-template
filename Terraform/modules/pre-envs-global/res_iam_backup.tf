data "aws_iam_policy_document" "backup" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "backup_role" {
  name               = "${var.solution_short}-backup"
  assume_role_policy = data.aws_iam_policy_document.backup.json

  tags = {
    Name = "${var.solution_short}-backup"
  }
}

resource "aws_iam_role_policy_attachment" "backup_role1" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

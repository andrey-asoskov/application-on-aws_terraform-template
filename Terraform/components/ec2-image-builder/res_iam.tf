data "aws_iam_policy_document" "image_builder_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "image_builder_role" {
  name               = "${var.solution_short}_ec2_image_builder_role"
  path               = "/${var.solution_short}/"
  assume_role_policy = data.aws_iam_policy_document.image_builder_role.json

  tags = {
    Name = "${var.solution_short}_ec2_image_builder_role"
  }
}

data "aws_iam_policy_document" "image_builder_role_policy" {
  statement {
    sid = "S3bucket"
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${data.terraform_remote_state.VPC.outputs.s3_access-logs_bucket_id}"
    ]
  }

  statement {
    sid = "S3objects"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${data.terraform_remote_state.VPC.outputs.s3_access-logs_bucket_id}/ec2-image-builder-logs/*"
    ]
  }
}

resource "aws_iam_policy" "image_builder_role_policy" {
  name        = "${var.solution_short}_ec2_image_builder_role_policy"
  path        = "/${var.solution_short}/"
  description = "${var.solution} - Policy for ec2 image_builder"
  policy      = data.aws_iam_policy_document.image_builder_role_policy.json

  tags = {
    Name = "${var.solution_short}_ec2_image_builder_role_policy"
  }
}

resource "aws_iam_role_policy_attachment" "image_builder_role1" {
  role       = aws_iam_role.image_builder_role.name
  policy_arn = aws_iam_policy.image_builder_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "image_builder_role2" {
  role       = aws_iam_role.image_builder_role.name
  policy_arn = data.terraform_remote_state.VPC.outputs.Policy_UseKMS_arn
}

resource "aws_iam_role_policy_attachment" "image_builder_role3" {
  role       = aws_iam_role.image_builder_role.name
  policy_arn = data.terraform_remote_state.pre-envs.outputs.global_Policy_AppGetFilesFromCodeBucket_arn
}

resource "aws_iam_role_policy_attachment" "image_builder_role4" {
  role       = aws_iam_role.image_builder_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "image_builder_role5" {
  role       = aws_iam_role.image_builder_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "image_builder_role6" {
  role       = aws_iam_role.image_builder_role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

resource "aws_iam_role_policy_attachment" "image_builder_role7" {
  role       = aws_iam_role.image_builder_role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

resource "aws_iam_instance_profile" "image_builder_role" {
  name = "ec2_image_builder_role"
  path = "/${var.solution_short}/"
  role = aws_iam_role.image_builder_role.name
}

resource "aws_s3_object" "forms" {
  bucket  = var.ec2ib_s3_bucket
  key     = "forms-${var.app_version}.yaml"
  content = local.AWSTOE_forms

  tags = {
    Name = "forms-${var.app_version}"
  }
}

resource "aws_s3_object" "trainer" {
  bucket  = var.ec2ib_s3_bucket
  key     = "trainer-${var.app_version}.yaml"
  content = local.AWSTOE_trainer

  tags = {
    Name = "trainer-${var.app_version}"
  }
}

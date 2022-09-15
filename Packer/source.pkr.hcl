data "amazon-ami" "ubuntu-20-cng" {
  filters = {
    virtualization-type = "hvm"
    name                = "CNG-CAP-Ubuntu20_04-CT-Base-*"
    root-device-type    = "ebs"
  }
  owners      = ["409661236178"]
  most_recent = true
  region      = "us-east-1"
}

source "amazon-ebs" "app" {
  ami_name             = "${var.solution_short}-${var.component}-${local.app_version2}-${local.timestamp}"
  ami_description      = "${var.solution} ${var.component} Ubuntu 20 CNG ${local.timestamp}"
  instance_type        = var.aws_instance_type
  region               = var.aws_region
  subnet_id            = var.aws_subnet_id
  vpc_id               = var.aws_vpc_id
  iam_instance_profile = var.aws_iam_instance_profile_name
  security_group_id    = var.aws_security_group_id

  source_ami = data.amazon-ami.ubuntu-20-cng.id
  #shutdown_behavior = "stop"
  shutdown_behavior = "terminate"

  aws_polling {
    delay_seconds = 60
    max_attempts  = 120
  }

  ssh_interface = "session_manager"
  ssh_username  = "ubuntu"

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    encrypted             = true
    volume_size           = 40
    kms_key_id            = var.aws_kms_key_id
    volume_type           = "gp3"
    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name           = "/dev/xvdb"
    encrypted             = true
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    kms_key_id            = var.aws_kms_key_id
  }

  ebs_optimized = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  #  encrypt_boot = true
  #  kms_key_id   = var.aws_kms_key_id
  # associate_public_ip_address = true

  run_tags = merge({
    Name                  = "Packer"
    AMI_Name              = "${var.solution_short}-${var.component}-${var.app_version}-${local.timestamp}"
    OS_Version            = "Ubuntu 20"
    Base_AMI_id           = "{{ .SourceAMI }}"
    Base_AMI_Name         = "{{ .SourceAMIName }}"
    Base_AMI_CreationDate = "{{ .SourceAMICreationDate }}"
  }, local.common_tags)

  tags = merge({
    Name                  = "${var.solution_short}-${var.component}-${var.app_version}-${local.timestamp}"
    OS_Version            = "Ubuntu 20"
    Base_AMI_id           = "{{ .SourceAMI }}"
    Base_AMI_Name         = "{{ .SourceAMIName }}"
    Base_AMI_CreationDate = "{{ .SourceAMICreationDate }}"
    BuildDate             = local.timestamp
  }, local.common_tags)
}

build {
  sources = ["source.amazon-ebs.app"]

  /*  provisioner "shell" {
    inline = [
      "sudo systemctl stop mdatp"
    ]
  }*/

  /*  provisioner "shell" {
    script = "./scripts/install_aws_cli2.sh"
  }*/

  /*  provisioner "shell" {
    environment_vars = ["AWS_REGION=${var.aws_region}"]
    script = "./scripts/install_codedeploy.sh"
  }*/

  /*  provisioner "shell" {
    environment_vars = ["AWS_REGION=${var.aws_region}"]
    script           = "./scripts/install_cloudwatch.sh"
  }*/

  provisioner "file" {
    source      = "../Terraform/components/ec2-image-builder/Ansible"
    destination = "/home/ubuntu"
  }

  provisioner "shell" {
    script = "./scripts/install_ansible.sh"
  }

  /*
  provisioner "ansible" {
    use_proxy       = false
    extra_arguments = ["--extra-vars", "ansible_remote_tmp=/tmp/.ansible/tmp", "--extra-vars", "app_version=${var.app_version}"]
    playbook_file   = "../Terraform/components/ec2-image-builder/Ansible/playbooks/${var.component}.yaml"
    #playbook_dir  = "../Terraform/components/ec2-image-builder/Ansible/playbooks"
    inventory_file_template = "{{ .HostAlias }} ansible_host={{ .ID }} ansible_user={{ .User }} ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand=\"sh -c \\\"aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p\\\"\"'\n"
  }
*/

  provisioner "shell" {
    environment_vars = [
      "app_version=${var.app_version}",
      "component=${var.component}",
    ]
    script = "./scripts/run_ansible.sh"
  }

  /*  provisioner "shell" {
    environment_vars = ["app_version=${var.app_version}"]
    script           = "./scripts/test_${var.component}.sh"
  } */
}

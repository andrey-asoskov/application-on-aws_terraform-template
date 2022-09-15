# Packer setup

## Description

Uses CNG images CNG-CAP-Ubuntu20_04-CT-Base-*

## Content

- Packer setup for app AMIs
- scripts - Scripts that are used to provision the AMIs

## Requirements

- Packer 1.7.0
- Ansible (Check Terraform/components/ec2-image-builder/Ansible/requirements.txt)

## Usage

```commandline
packer init .
packer fmt .

packer validate -var-file=./variables.pkrvars.hcl \
-var 'app_version=32.0.11' \
-var 'component=forms' .

export AWS_*

packer build -var-file=./variables.pkrvars.hcl \
-var 'app_version=32.0.11' \
-var 'component=forms' \
-on-error=abort .
```

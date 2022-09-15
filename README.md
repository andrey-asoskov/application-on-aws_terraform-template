# application-on-aws_terraform-template

- Terraform template for application hosted on AWS EC2 in many environments using TF modules.
- Checks via: TF validate, TFsec, TFlint, Checkov.
- Also includes Ansible playbooks to setup EC2 images and Packer config.

Used AWS services:
- Network: VPC, VPC endpoints, VPC Flow Logs, NAT Gateway, R53, ALB, CloudFront
- Security: IAM, KMS, NACL, SG, WAF, CloudTrail, OIDC, Secrets Manager, ACM
- Storage: RDS, S3, Backup, Kinesis
- Compute: ASG/EC2, EC2 Image builder, Lambda
- Monitoring: CloudWatch, SNS

## Branching

- master: Prod Environment
- develop: NPN Environments
- For new features: merge to develop branch
- To apply on Prod: merge develop to master

## Prerequisites

- tfenv 2.2.0
- terragrunt version v0.36.7
- pyenv 2.2.5
- AWS CLI 2.1.26

## Contents

- **.github/workflows/** - GHA workflows for linting and deploying the Infra
- **Terraform/**   - Terraform config
  - **components/** - Terraform components
    - **App-Forms/** - Compute component 1
    - **App-Trainer/** - Compute component 2
    - **Data/** - Application data: Database and S3 Bucket
    - **ec2-image-builder/** - Config to create AMI images for Forms and Trainer
      - **Ansible/** - Ansible playbooks that are run by EC2 Image Builder/Packer to configure AMIs
    - **new-relic/** - New Relic monitors and Selenium scripts
    - **pre-envs/** - Common Infra for all environments in an AWS account (incl. Python Lambdas). Should be deployed before any environment
    - **Splunk-HF/** - Config to forward logs to Splunk Cloud
    - **TFE/** - Terraform config to create TFE workspaces
    - **VPC/** - Network and KMS config
  - **modules/** - Terraform modules
- **Packer/** - Packer config to create AMIs (a backup option for EC2 Image Builder)
- **.guardrails** - GuardRails config
- **.pre-commit-config.yaml** - Pre-commit config for testing the config locally
- **.checkov.yaml**
- **.flake8**
- **.markdownlint.yaml**
- **.pylitrc**
- **.terraformignore**
- **.yamllint.yaml**

## Usage

### Do the changes

```commandline
cd Terraform/components/<component> #Select the component
terraform workspace select dev      #Select the environment
terraform apply                     #Apply the changes
```

### Encrypt secret data

```commandline
# Encrypt
echo -n TestTesT | base64  #base64 => VGVzdFRlc1Q=
aws kms encrypt \
    --key-id <key_id> \
    --query CiphertextBlob \
    --output text \
    --plaintext 'VGVzdFRlc1Q='

# Decrypt
aws kms decrypt \
    --ciphertext-blob "encrypted data" \
    --output text \
    --query Plaintext | base64 -d   
```

### Connect to DB from Forms EC2

```commandline
yum install -y postgresql
psql -d hs_db -h db.dev.app.company.com -p 5432 -U hs_user

#SSL
psql -h db.dev.app.company.com -p 5432 "dbname=hs_db user=hs_user sslrootcert=global-bundle.pem sslmode=verify-ca"

#Test that SSL is used
create extension sslinfo;
select ssl_is_used();

## Delete all the data
#Empty the DB
\c hs_db
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
\q
#Empty the S3 bucket

#Empty file storage
rm -rf /mnt/hs/*
```

### Update the list of allowed ip addresses

Official list of Company external IPs can be found here: <http://ips.intranet.company.com/api/v2/egress-ip>

```commandline
wget http://ips.intranet.company.com/api/v2/egress-ip
cat egress-ip | jq '.response[]["ip network"]'| sed -e 's/\"$/\/32\",/g'| sed '$ s/.$//' > company_ips.txt
```

List of AWS R53 Health Checks outgoing IP addresses

```commandline
wget https://ip-ranges.amazonaws.com/ip-ranges.json
cat ip-ranges.json | jq -r '.prefixes[] | select(.service == "ROUTE53_HEALTHCHECKS") | .ip_prefix' | sed 's/$/",/' | sed 's/^/"/'
```

List of AWS CloudFront outgoing IP addresses

```commandline
wget https://ip-ranges.amazonaws.com/ip-ranges.json
cat ip-ranges.json | jq -r '.prefixes[] | select(.service == "CLOUDFRONT_ORIGIN_FACING") | .ip_prefix' | sed 's/$/",/' | sed 's/^/"/'
```

List of NewRelic Synthetic monitoring outgoing IP addresses

```commandline
wget https://s3.amazonaws.com/nr-synthetics-assets/nat-ip-dnsname/production/ip.json -O us_ip.json
cat ./us_ip.json | jq '.[]' | grep -v '\[' | grep -v '\]' | sed 's/,$//' | sed 's/\"$/\/32",/'

wget https://s3.amazonaws.com/nr-synthetics-assets/nat-ip-dnsname/eu/ip.json -O eu_ip.json
cat ./eu_ip.json | jq '.[]' | grep -v '\[' | grep -v '\]' | sed 's/,$//' | sed 's/\"$/\/32",/'
```

### Create a new environment

- Add the following workspaces into TF files in Terraform/components/TFE/ folder. Set Env Vars AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY for each workspace manually via TFE UI:
  - ```VPC-<env>```
  - ```Data-<env>```
  - ```Splunk-HF-<env>```
  - ```App-Forms-<env>```
  - ```App-Trainer-<env>```
- Create the new workspaces in the TFE folder via: ```terraform apply```
- Add environment specific variables into variables.tf for each component:
- Run terraform for each component:

```commandline
terraform init
terraform workspace select <env>
terraform apply
```

### Create images for a new app version:

1. Update app version in var file for ec2-image-builder component
2. Run ```terraform apply``` for EC2 Image Builder component

### Grant Prod AWS Account rights to use key from Dev AWS Account:

This is required for AutoScaling

```commandline
aws kms create-grant \
  --region us-east-1 \
  --key-id arn:aws:kms:us-east-1:<aws_account_id>:key/<key_id> \
  --grantee-principal arn:aws:iam::<aws_account_id>:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling \
  --operations "Encrypt" "Decrypt" "ReEncryptFrom" "ReEncryptTo" "GenerateDataKey" "GenerateDataKeyWithoutPlaintext" "DescribeKey" "CreateGrant"
```

### Share image from NPN AWS Account to Prod AWS Account

1. Setup sharing in NPN AWS Account (including access to snapshots)
2. Manualy set Tag:Name for an images in Prod AWS Account to be the same as in NPN AWS Account (as Tags are not shared)

## Migrating to a new version

### Run security tests via JFrog XRay on docker images

```commandline
1. Upload to s3://app-code-bucket/App/
2. Extract zip package and upload docker images to JFrog. The script is below

export VER=32.0.10 #Replace with release version
docker login -u svc_app_rw -p *** company-app-docker.jfrog.io
docker image load -i ./forms.tar
docker tag forms:${VER} company-app-docker.jfrog.io/app-docker:${VER}
docker push company-app-docker.jfrog.io/app-docker:${VER}

docker login -u svc_postgres_rw -p *** company-postgres-docker.jfrog.io
docker image load -i ./postgres.tar
docker tag postgres:${VER} company-postgres-docker.jfrog.io/postgres-docker:${VER}
docker push company-postgres-docker.jfrog.io/postgres-docker:${VER}

```

### Create the image for a new release

1. Upload installation bundle to S3:

    ```commandline
    aws s3 cp ./app-trainer-31.0.13.tgz s3://app-code-bucket/App/
    ```

2. Run Packer

### Replace EC2s

1. Make only 1 EC2 running
2. Disable autoscaling actions
3. Kill all containers
4. Run "run.sh init" and wait for a container to exit
5. Run "run.sh"
6. Enable autoscaling actions when load is low

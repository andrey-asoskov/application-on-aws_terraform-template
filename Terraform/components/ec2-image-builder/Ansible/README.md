# Ansible

## Install Ansible

```commandline
python3 -m pip install -r ./requirements.txt
ansible-playbook --version
  
ansible-galaxy collection install -r ./collections/requirements.yml
```

### Test Ansible playbooks

```commandline
#Test playbooks
ansible-lint -c ./playbooks/.ansible-lint ./playbooks/forms.yaml

#Test the connection
ansible -m ping \
-e ansible_connection=aws_ssm \
-e ansible_aws_ssm_timeout=600 \
-e ansible_aws_ssm_bucket_name=925851635913-app-code-bucket \
-i 'i-01fa72d3392fe2349,' \
all

#Test the playbook
ansible-playbook \
-e ansible_connection=aws_ssm \
-e ansible_aws_ssm_timeout=600 \
-e ansible_aws_ssm_bucket_name=925851635913-app-code-bucket \
-e app_version=32.0.11 \
-i "i-01fa72d3392fe2349," \
./trainer.yaml

#Just specific tasks
ansible-playbook \
-e ansible_connection=aws_ssm \
-e ansible_aws_ssm_timeout=600 \
-e ansible_aws_ssm_bucket_name=925851635913-app-code-bucket \
-e app_version=32.0.11 \
-i "i-01fa72d3392fe2349," \
./trainer.yaml  --tags "test"

##Transfer to target machine - need to put a key and export AWS env vars
#Via SSM over SSH
rsync -avh ./Ansible/ ubuntu@i-0a444bfdca7e77aad:~/Ansible/

#Run Ansible locally
ansible-playbook \
-c local \
-e app_version=32.0.11 \
-i "127.0.0.1," \
./forms.yaml
```

### Collect logs

Params can be configured in role's defaults file

```commandline
#Collect and download logs

<export AWS creds>

ansible-playbook  -e environment=prod -e app_version=32.0.17 ./collect_logs.yaml
```

### Execute commands on all hosts

```commandline
<export AWS creds>

ansible -m ping \
-e ansible_connection=aws_ssm \
-e ansible_aws_ssm_timeout=180 \
-e ansible_aws_ssm_bucket_name=925851635913-app-staging-access-logs \
aws_ec2

ansible -m command -a "" \
-e ansible_connection=aws_ssm \
-e ansible_aws_ssm_timeout=180 \
-e ansible_aws_ssm_bucket_name=925851635913-app-staging-access-logs \
aws_ec2

ansible -m shell -a "sed -i -e 's/max_log_file_action.*/max_log_file_action = rotate/g'  /etc/audit/auditd.conf; sed -i -e 's/space_left_action.*/space_left_action = rotate/g'  /etc/audit/auditd.conf; systemctl restart auditd" \
-e ansible_connection=aws_ssm \
-e ansible_aws_ssm_timeout=180 \
-e ansible_aws_ssm_bucket_name=925851635913-app-staging-access-logs \
i-05dd5e3dea61f16e5

ansible -m shell -a "sed -i -e 's/max_log_file_action.*/max_log_file_action = rotate/g'  /etc/audit/auditd.conf; sed -i -e 's/space_left_action.*/space_left_action = rotate/g'  /etc/audit/auditd.conf; systemctl restart auditd" \
-e ansible_connection=aws_ssm \
-e ansible_aws_ssm_timeout=180 \
-e ansible_aws_ssm_bucket_name=925851635913-app-staging-access-logs \
tag_component_forms

ansible -m shell -a "sed -i -e 's/max_log_file_action.*/max_log_file_action = rotate/g'  /etc/audit/auditd.conf; sed -i -e 's/space_left_action.*/space_left_action = rotate/g'  /etc/audit/auditd.conf; systemctl restart auditd" \
-e ansible_connection=aws_ssm \
-e ansible_aws_ssm_timeout=180 \
-e ansible_aws_ssm_bucket_name=925851635913-app-staging-access-logs \
tag_component_trainer
```

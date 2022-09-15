#!/bin/bash -ex
# sudo apt-add-repository ppa:ansible/ansible
# sudo apt-get update
# sudo apt-get install -y ansible
# echo 'DEFAULT_LOCAL_TMP=/tmp/' >> /home/ubuntu/.profile

export PATH="/home/ubuntu/.local/bin:${PATH}"
python3 -m pip install -r /home/ubuntu/Ansible/requirements.txt
ansible-playbook --version
  
ansible-galaxy collection install -r /home/ubuntu/Ansible/collections/requirements.yml

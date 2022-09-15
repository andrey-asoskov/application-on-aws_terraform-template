#!/bin/bash -ex
# shellcheck disable=SC2154

export PATH="/home/ubuntu/.local/bin:${PATH}"
ansible-playbook --version

ansible-playbook -c local -i '127.0.0.1,' \
--extra-vars ansible_remote_tmp=/tmp/.ansible/tmp \
--extra-vars app_version="${app_version}" \
/home/ubuntu/Ansible/playbooks/"${component}".yaml

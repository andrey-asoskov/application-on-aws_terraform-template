#!/bin/bash -ex
# shellcheck disable=SC2154

aws --version | grep "aws-cli/2"

systemctl is-active snap.amazon-ssm-agent.amazon-ssm-agent.service
systemctl is-enabled snap.amazon-ssm-agent.amazon-ssm-agent.service

sudo docker image inspect forms:"${app_version}" | grep Container

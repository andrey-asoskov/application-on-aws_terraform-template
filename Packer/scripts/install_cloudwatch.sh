#!/bin/bash -ex

#wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
wget https://s3."${AWS_REGION}".amazonaws.com/amazoncloudwatch-agent-"${AWS_REGION}"/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

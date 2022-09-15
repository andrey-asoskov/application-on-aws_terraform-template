#!/bin/bash -ex

#sudo killall apt apt-get || true
sudo apt-get update
sudo apt install -y ruby-full
sudo apt install -y wget

cd /tmp
wget https://aws-codedeploy-"${AWS_REGION}".s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent status
#sudo usermod -a -G root ubuntu

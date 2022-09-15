#!/bin/bash
# shellcheck disable=SC2154

set -x

#Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

#Instance ID
instanceid=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

#Account ID
accountid=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info| jq -r .AccountId)

#Instance Name
# shellcheck disable=SC2034
instancename=$(/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$instanceid" "Name=key,Values=Name" --output=text --region "${REGION}" | cut -f5)


#echo 'export AWS_REGION=${REGION}' >> /home/ubuntu/.bashrc
# it should be splunk heavy
SPLUNK_HOME=/opt/splunk
#SPLUNK_CMD=$${SPLUNK_HOME}/bin/splunk

#Create config files
cat > $SPLUNK_HOME/etc/system/local/inputs.conf <<EOL1
[default]
host = ${splunk_hf_elb_dns}
[splunktcp://9997]
disabled = false
[tcp://5514]
sourcetype = syslog
EOL1

cat > $SPLUNK_HOME/etc/system/local/outputs.conf <<EOL2
[tcpout]
forwardedindex.filter.disable = true
defaultGroup = splunkcloud
EOL2

cat > ${SPLUNK_HOME}/etc/system/local/props.conf <<EOL3
[splunkd]
TRANSFORMS-routing=transforms_splunkd
[splunk_resource_usage]
TRANSFORMS-routing=transforms_splunk_resource_usage
[kvstore]
TRANSFORMS-routing=transforms_kvstore
[splunk_disk_objects]
TRANSFORMS-routing=transforms_splunk_disk_objects
[splunkd_access]
TRANSFORMS-routing=transforms_splunkd_access
[mongod]
TRANSFORMS-routing=transforms_mongod
[scheduler]
TRANSFORMS-routing=transforms_scheduler
[splunkd_stderr]
TRANSFORMS-routing=transforms_stderr
[splunk_btool]
TRANSFORMS-routing=transforms_btool
[default]
TRANSFORMS-routing=transforms_td,transforms_default
TRANSFORMS-z-last_transform = add_raw_length_to_meta_field

[pm2]
SHOULD_LINEMERGE = true
MUST_BREAK_AFTER = \d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z\"\}
category = Custom
EOL3

cat >> $SPLUNK_HOME/etc/system/local/transforms.conf <<EOL5
[add_raw_length_to_meta_field]
INGEST_EVAL = event_length=len(_raw)

[transforms_td]
FORMAT = company_external_site::ct_${name}
REGEX = .
WRITE_META = true

[transforms_default]
DEST_KEY = _MetaData:Index
FORMAT = ${index_name}
REGEX=.
EOL5

cat >$SPLUNK_HOME/etc/system/local/deploymentclient.conf <<EOL6
[deployment-client]
clientName=splunktd-hf-${name}-${env}-us-east-1.company-solutions.com # example: splunktd-hf-cls-dev-us-east-1.company-solutions.com
[target-broker:deploymentServer]
targetUri=${target_uri} # production HFs replace with splunk-aws-us-east-1.company-solutions.com:8089
EOL6


####SPLUNK CONFIGURATION####################################

# change the password
#$SPLUNK_CMD edit user admin -password '$${ADMIN_PWD}' -role admin -auth admin:changeme
# enable SplunkDeployment
#$SPLUNK_CMD enable app SplunkForwarder -auth 'admin':'$${ADMIN_PWD}'

#chown to splunk:splunk

#chown splunk:splunk $${SPLUNK_HOME}/etc/system/local/outputs.conf

# restart splunk
service splunk restart

######### NESSUS CONFIGURATION  ############
NESSUS_KEY=$(/usr/local/bin/aws kms decrypt --ciphertext-blob "${NESSUS_KEY_CIPHERTEXT}" --output text --query Plaintext --region "${REGION}")

/etc/init.d/nessusagent start
/opt/nessus_agent/sbin/nessuscli agent link --key="$NESSUS_KEY" --groups="$accountid" --cloud


######### NEW RELIC CONFIGURATION  ############
NEWRELICKEY=$(/usr/local/bin/aws kms decrypt --ciphertext-blob "${NEWRELIC_KEY_CIPHERTEXT}" --output text --query Plaintext --region "${REGION}")

cat >/etc/newrelic-infra.yml <<EOL5
license_key: $NEWRELICKEY
display_name: $(instancename)_$(instanceid)
EOL5
systemctl restart newrelic-infra

######### MICROSOFT DEFENDER CONFIGURATION ############
accountinstance=ClienTech_$(accountid)_$(instanceid)

systemctl stop msdefender-tag.service
systemctl disable msdefender-tag.service
sudo mdatp edr tag set --name GROUP --value "$accountinstance"

sudo mdatp config real-time-protection --value disabled
# MS Defender create exclusion list
sudo mdatp exclusion folder add --path "/opt/"
sudo mdatp exclusion folder add --path "/var/log/"
#sudo mdatp exclusion folder add --path "/home/ubuntu/"
sudo mdatp exclusion folder add --path "/proc/"
sudo mdatp exclusion folder add --path "/sys/"
sudo mdatp exclusion folder add --path "/dev/"
#sudo mdatp exclusion process add --name node
sudo mdatp exclusion process add --name nessusd
sudo mdatp exclusion process add --name nessus-service
sudo mdatp exclusion process add --name ssm-agent-worker
sudo mdatp exclusion process add --name newrelic-infra-service
sudo mdatp exclusion process add --name newrelic-infra
sudo mdatp exclusion process add --name splunkd

#yum update --security

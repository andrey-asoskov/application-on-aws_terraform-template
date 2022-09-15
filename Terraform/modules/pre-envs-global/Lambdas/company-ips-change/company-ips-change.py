"""Module that updates WAF with AWS IP CF addresses"""
import json
import os
from datetime import datetime
import boto3

"""
Event example:

{
  "Records": [
    {
      "EventSource": "aws:sns",
      "EventVersion": "1.0",
      "EventSubscriptionArn": "arn:aws:sns:us-east-1:933806036560:ipwl_update:ea571684-6d28-4880-8280-a9046dbf3fbc",
      "Sns": {
        "Type": "Notification",
        "MessageId": "bc6ab8e8-39b8-5455-9b80-eebf3542664e",
        "TopicArn": "arn:aws:sns:us-east-1:933806036560:ipwl_update",
        "Subject": "company External IPs update",
        "Message": "{\"eventtype\": \"update\", \"eventdata\": {\"version\": 1, \"context\": \"company-external-ips\", \"resource\": \"s3://ndm-repo-shared-data/external-ips/offices-and-vpn/company-external-ips.json\"}}",
        "Timestamp": "2019-11-26T11:21:30.597Z",
        "SignatureVersion": "1",
        "Signature": "jSXpNtg4Ny9KEnUGrQnaSDNbdJgQiTBAaA9WzJZcrcsvPTfcvGkGDZJccf7AB7U6ipwqDODXeFejIpQ9cnJiJBa9fMUB2bjGLxqK7mNnJf9D7BRdxgVhG7UvKtxWwzltA3rKfsPdF78Ol1SguQkfMuJDvAzBUB90S/UUkyn9kOLFueAvGzNwa/Exji4qdFao2OG3GeDr/eSjinWRERtI9/X2BVFl9j1ZVtV82XRpT/OqU/Fm7gagIy/wY1Dr8ZBIJJV6ReDCo/P3oglghrr6fed3ruTUBWR2e5xvQQtpOzEh8LSHX8eWfrIX15OoZFWIPL74MFsNvJ8gAzxbInsOeg==",
        "SigningCertUrl": "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-6aad65c2f9911b05cd53efda11f913f9.pem",
        "UnsubscribeUrl": "https://sns.us-east-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-east-1:933806036560:ipwl_update:ea571684-6d28-4880-8280-a9046dbf3fbc",
        "MessageAttributes": {}
      }
    }
  ]
}

"""


def handler(event, context):
    """Function to update WAFv2 IP-set with Company external IP addresses"""
    print('INFO: Event is: ', event)
    print('INFO: Context is: ', context)

    waf_ip_set_name = os.environ.get('waf_ip_set_name')
    print('INFO: waf_ip_set_name: ', waf_ip_set_name)
    waf_ip_set_scope = os.environ.get('waf_ip_set_scope')
    print('INFO: waf_ip_set_scope: ', waf_ip_set_scope)

    print('INFO: S3 path: ' + json.loads(event['Records'][-1]['Sns']['Message'])['eventdata']['resource'])

    path_parts = json.loads(event['Records'][-1]['Sns']['Message']
                            )['eventdata']['resource'].replace('s3://', '').split('/')
    s3_bucket = path_parts.pop(0)
    s3_key = '/'.join(path_parts)
    print('INFO: s3_bucket: ', s3_bucket)
    print('INFO: s3_key: ', s3_key)

    ips_list = []
    response = {}

    s3 = boto3.client('s3')
    print('INFO: reading s3 object')
    response = s3.get_object(Bucket=s3_bucket, Key=s3_key)

    data = json.load(response['Body'])
    for i in data['response']:
        ips_list.append(i['ip network'].strip() + '/32')

    client = boto3.client('wafv2')

    print('INFO: listing WAF ip sets')
    response = client.list_ip_sets(
      Scope=waf_ip_set_scope,
    )
    print('INFO: WAF ip sets: ', response)

    for i in response['IPSets']:
      if i['Name'] == waf_ip_set_name:
        print('INFO: updating WAF IP set')
        response = client.update_ip_set(
          Name=waf_ip_set_name,
          Scope=waf_ip_set_scope,
          Id=i['Id'],
          Description='company-External-IPs_' + datetime.utcnow().isoformat() + '-UTC',
          Addresses=ips_list,
          LockToken=i['LockToken']
        )
        print('INFO: updated WAF IP set: ', response)
    return 0


# For local tests. Need to export AWS creds env vars
def test_handler():
    """Function to test"""
    test_context = ''
    filename = './payload.json'
    with open(filename, 'r', encoding='utf-8') as f:
        test_event = json.load(f)

    os.environ["waf_ip_set_name"] = "company-External-IPs"
    os.environ["waf_ip_set_scope"] = "CLOUDFRONT"

    assert handler(test_event, test_context) == 0

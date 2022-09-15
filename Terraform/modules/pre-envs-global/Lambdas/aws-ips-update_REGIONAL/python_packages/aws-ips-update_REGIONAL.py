"""Module that updates WAF with AWS IP CF addresses"""
from datetime import datetime
import json
import os
import boto3
import botocore.config
import requests

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
        "TopicArn": "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged",
        "Subject": "IP Space Changed",
        "Message": "{\"create-time\":\"2022-04-27-19-03-26\",\"synctoken\":\"1651086206\",\"md5\":\"40741c8787f418fa91d0f20d9f25b735\",\"url\":\"https://ip-ranges.amazonaws.com/ip-ranges.json\"}",
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
    """Function"""
    print('INFO: Event is: ', event)
    print('INFO: Context is: ', context)

    waf_ip_set_name = os.environ.get('waf_ip_set_name')
    print('INFO: waf_ip_set_name: ', waf_ip_set_name)
    waf_ip_set_scope = os.environ.get('waf_ip_set_scope')
    print('INFO: waf_ip_set_scope: ', waf_ip_set_scope)
    aws_regions = os.environ.get('aws_regions').split(',')
    print('INFO: regions: ', aws_regions)

    # aws_url = json.loads(event['Records'][-1]['body'])['url']
    aws_url = json.loads(event['Records'][-1]['Sns']['Message'])['url']

    print('INFO: URL: ' + aws_url)

    response = {}
    print('INFO: downloading JSON file')
    ip_ranges = requests.get(aws_url).json()['prefixes']

    cloudfront_ips = [item['ip_prefix']
                      for item in ip_ranges if item["service"] == "CLOUDFRONT_ORIGIN_FACING"]
    print('INFO: List of CloudFront IPs: ', cloudfront_ips)

    for region in aws_regions:
        my_config = botocore.config.Config(
          region_name=region
        )
        client = boto3.client('wafv2', config=my_config)

        print('INFO: listing WAF ip sets: ' + region)
        response = client.list_ip_sets(Scope=waf_ip_set_scope)

        for i in response['IPSets']:
          if i['Name'] == waf_ip_set_name:
            print('INFO: updating WAF IP set')
            response = client.update_ip_set(
              Name=waf_ip_set_name,
              Scope=waf_ip_set_scope,
              Id=i['Id'],
              Description='AWS-CloudFront-IP-ranges_' + datetime.utcnow().isoformat() + '-UTC',
              Addresses=cloudfront_ips,
              LockToken=i['LockToken']
            )
            break


# For local tests
if __name__ == '__main__':
    test_context = ''

    filename = '../payload.json'
    with open(filename, 'r', encoding='utf-8') as f:
        test_event = json.load(f)

    os.environ["waf_ip_set_name"] = "AWS-CloudFront-IP-ranges"
    os.environ["waf_ip_set_scope"] = "REGIONAL"
    os.environ["aws_regions"] = "us-east-1,eu-west-2"

    handler(test_event, test_context)

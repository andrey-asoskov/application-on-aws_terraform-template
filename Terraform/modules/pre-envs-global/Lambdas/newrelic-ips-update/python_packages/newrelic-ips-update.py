"""Module that updates WAF with New Relic IP addresses"""
from datetime import datetime
import os
import json
import boto3
import requests


""" # pylint: disable=W0105
Event example:
{
  "Records": "null"
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
    # aws_url = json.loads(event['Records'][-1]['body'])['url']
    aws_url_us_ranges = "https://s3.amazonaws.com/nr-synthetics-assets/nat-ip-dnsname/production/ip-ranges.json"
    aws_url_eu_ranges = "https://s3.amazonaws.com/nr-synthetics-assets/nat-ip-dnsname/eu/ip-ranges.json"

    aws_url_us_ips = "https://s3.amazonaws.com/nr-synthetics-assets/nat-ip-dnsname/production/ip.json"
    aws_url_eu_ips = "https://s3.amazonaws.com/nr-synthetics-assets/nat-ip-dnsname/eu/ip.json"

    response = {}
    print('INFO: downloading JSON files')
    ip_ranges_us = requests.get(aws_url_us_ranges).json()
    ip_ranges_eu = requests.get(aws_url_eu_ranges).json()

    ips_us = requests.get(aws_url_us_ips).json()
    ips_eu = requests.get(aws_url_eu_ips).json()

    newrelic_ips_and_ranges = []

    for i in ip_ranges_us.values():
      for j in i:
        newrelic_ips_and_ranges.append(j)

    for i in ip_ranges_eu.values():
      for j in i:
        newrelic_ips_and_ranges.append(j)

    for i in ips_us.values():
      for j in i:
        newrelic_ips_and_ranges.append(j + "/32")

    for i in ips_eu.values():
      for j in i:
        newrelic_ips_and_ranges.append(j + "/32")

    print('INFO: List of New Relic IPs (US+EU): ', newrelic_ips_and_ranges)

    client = boto3.client('wafv2')
    print('INFO: listing WAF ip sets')
    response = client.list_ip_sets(
      Scope=waf_ip_set_scope,
    )

    for i in response['IPSets']:
      if i['Name'] == waf_ip_set_name:
        print('INFO: updating WAF IP set')
        response = client.update_ip_set(
          Name=waf_ip_set_name,
          Scope=waf_ip_set_scope,
          Id=i['Id'],
          Description='NR-Synthetic-monitoring-IP-ranges_' + datetime.utcnow().isoformat() + '-UTC',
          Addresses=newrelic_ips_and_ranges,
          LockToken=i['LockToken']
        )
        break


# For local tests
if __name__ == '__main__':
    test_context = ''

    filename = '../payload.json'
    with open(filename, 'r', encoding='utf-8') as f:
        test_event = json.load(f)

    os.environ["waf_ip_set_name"] = "NR-Synthetic-monitoring-IP-ranges"
    os.environ["waf_ip_set_scope"] = "CLOUDFRONT"

    handler(test_event, test_context)

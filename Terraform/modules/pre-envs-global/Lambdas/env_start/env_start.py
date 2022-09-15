"""Module that updates WAF with AWS IP CF addresses"""
import boto3

"""
Event example:

event =
{"environment": "dev"}

"""


def turn_on(event, context):
  """
  Starts ec2 instances that have a value of 'true' for the tag 'shutOff' and stopped state
  """
  ec2 = boto3.client('ec2')
  asclient = boto3.client('autoscaling')
  rds = boto3.client('rds')
  environment = event['environment']
  print('INFO: Event is: ', event)
  print('INFO: Context is: ', context)

  # Start DBs
  dbs = rds.describe_db_instances()

  def get_tags_for_db(db):
    instance_arn = db['DBInstanceArn']
    instance_tags = rds.list_tags_for_resource(ResourceName=instance_arn)
    return instance_tags['TagList']

  target_db = None
  db_list = []

  for db in dbs['DBInstances']:  # NOSONAR
    if db['DBInstanceStatus'] == 'stopped':
      db_tags = get_tags_for_db(db)
      # print("DB tags of: ",db['DBInstanceIdentifier'], " : ", db_tags)
      tag = next(iter(filter(
        lambda tag: tag['Key'] == 'shutOff' and tag['Value'] == 'true', db_tags)), None)
      tag2 = next(iter(filter(
        lambda tag: tag['Key'] == 'Environment' and tag['Value'] == environment, db_tags)), None)
      if tag and tag2:
        target_db = db
        db_list.append(target_db['DBInstanceIdentifier'])

  print("DB ids to start: ", db_list)

  for db in db_list:
    print("Starting the DB: ", db)
    boto3.client('rds').start_db_instance(DBInstanceIdentifier=db)

  # Start EC2s
  reservations = ec2.describe_instances(
    Filters=[
      {
        'Name': 'tag:shutOff',
        'Values': [
          'true'
        ]
      },
      {
        'Name': 'instance-state-name',
        'Values': [
          'stopped'
        ]
      },
      {
        'Name': 'tag:Environment',
        'Values': [
          environment
        ]
      },
    ]
  ).get('Reservations', [])

  instances = sum([[i for i in r['Instances']] for r in reservations], [])  # pylint: disable=unnecessary-comprehension
  ASGs_to_start = set()

  for i in instances:
    # Start EC2s
    print("Starting EC2 instance: ", i['InstanceId'])
    start_status = ec2.start_instances(
      InstanceIds=[i['InstanceId']]
    )
    print("Start status: ", start_status)

    waiter = ec2.get_waiter('instance_running')
    waiter.wait(
      InstanceIds=[i['InstanceId']]
    )

    # create a list of ASGs to resume
    for j in i['Tags']:
      if j['Key'] == 'aws:autoscaling:groupName':
        ASGs_to_start.add(j['Value'])

  for i in ASGs_to_start:
    print("Resuming ASG: ", i)
    asclient.resume_processes(
      AutoScalingGroupName=i,
      ScalingProcesses=[
        'Launch',
        'Terminate',
        'HealthCheck',
        'ReplaceUnhealthy',
        'AZRebalance'
      ])

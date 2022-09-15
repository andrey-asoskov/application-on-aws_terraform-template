"""Module that updates WAF with AWS IP CF addresses"""
import boto3


def shut_off(event, context):
  """
  shuts off ec2 instances that have a value of 'true' for the tag 'shutOff'
  """
  ec2 = boto3.client('ec2')
  asclient = boto3.client('autoscaling')
  rds = boto3.client('rds')

  print('INFO: Event is: ', event)
  print('INFO: Context is: ', context)

  # get reservations that contain instances that have a tag of 'shutOff'
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
          'running'
        ]
      }
    ]
  ).get('Reservations', [])

  instances = sum([[i for i in r['Instances']] for r in reservations], [])  # pylint: disable=unnecessary-comprehension

  for i in instances:
    # Suspend ASGs
    for j in i['Tags']:
      if j['Key'] == 'aws:autoscaling:groupName':
        print("Suspending ASG: ", j['Value'])
        asclient.suspend_processes(
          AutoScalingGroupName=j['Value'],
          ScalingProcesses=[
            'Launch',
            'Terminate',
            'HealthCheck',
            'ReplaceUnhealthy',
            'AZRebalance'
          ])

    # Stop EC2s
    print("Stopping EC2 instance: ", i['InstanceId'])
    ec2.stop_instances(
      InstanceIds=[i['InstanceId']]
    )

  # Stop DBs
  dbs = rds.describe_db_instances()

  def get_tags_for_db(db):
    instance_arn = db['DBInstanceArn']
    instance_tags = rds.list_tags_for_resource(ResourceName=instance_arn)
    return instance_tags['TagList']

  target_db = None
  db_list = []

  for db in dbs['DBInstances']:
    if db['DBInstanceStatus'] == 'available':
      db_tags = get_tags_for_db(db)
      tag = next(iter(filter(lambda tag: tag['Key'] == 'shutOff' and tag['Value'] == 'true', db_tags)), None)
      if tag:
        target_db = db
        db_list.append(target_db['DBInstanceIdentifier'])

  print("DB ids to stop: ", db_list)

  for db in db_list:
    print("Stopping the DB: ", db)
    boto3.client('rds').stop_db_instance(DBInstanceIdentifier=db)

#!/bin/bash

image_id=ami-09693313102a30b2c
instance_type=t2.micro
vpc_id=vpc-0e4dfd64aef6a44fc
key_name=user6
shutdown_type=stop
security_group=...
subnet_id=subnet-0a8edbfe14d168679
tags="ResourceType=instance,Tags=[{Key=Name,Value=user6-1}]"

start()
{

  private_ip_addr="10.3.1.61"
  public_ip=associate-public-ip-address

  aws ec2 run-instances \
    --image-id "$image_id" \
    --instance-type "$instance_type" \
    --key-name "$key_name" \
    --subnet-id "$subnet_id" \
    --instance-initiated-shutdown-behavior "$shutdown_type" \
    --private-ip-address "$private_ip_addr" \
    --tag-specifications "$tags" \
    --${public_ip}

    #--elastic-gpu-specification <value> \
    #--elastic-inference-accelerators <value> \
    #--security-groups "$security_group" \
    #--user-data <value> \
    #--additional-info <value> \
}

stop()
{
  ids=($(
    aws ec2 describe-instances \
    --query 'Reservations[*].Instances[?KeyName==`'$key_name'`].InstanceId' \
    --output text
  ))
  aws ec2 terminate-instances --instance-ids "${ids[@]}"
}

if [ "$1" = start ]; then
  start
elif [ "$1" = stop ]; then
  stop
else
  cat <<EOF
Usage:

  $0 start|stop
EOF
fi

#!/bin/bash

IMAGE_ID=ami-02fc24d56bc5f3d67 #ami-09693313102a30b2c
INSTANCE_TYPE=t2.micro
VPC_ID=vpc-0e4dfd64aef6a44fc
KEY_NAME=user6
USER_NAME=user6-vpc3
SHUTDOWN_TYPE=stop
SECURITY_GROUP=sg-0f0cc75216aa3485b
SUBNET_ID=subnet-0a8edbfe14d168679
TAGS="ResourceType=instance,Tags=[{Key=Name,Value=NAME},{Key=tag,Value=${KEY_NAME}}]"

start_vm()
{

  local private_ip_addr="$1"
  local public_ip="$2"
  local name="$3"

  local tags=$(echo $TAGS | sed s/NAME/$name/)
  #local tags=$(TAGS/NAME/$name)

  aws ec2 run-instances \
    --image-id "$IMAGE_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --subnet-id "$SUBNET_ID" \
    --instance-initiated-shutdown-behavior "$SHUTDOWN_TYPE" \
    --private-ip-address "$private_ip_addr" \
    --tag-specifications "$tags" \
    --${public_ip} \
    --security-group-id "$SECURITY_GROUP"

    #--elastic-gpu-specification <value> \
    #--elastic-inference-accelerators <value> \
    #--security-groups "$security_group" \
    #--user-data <value> \
    #--additional-info <value> \
}

get_dns_name()
{
  local instances="$1"

  aws ec2 describe-instances --instance-ids ${instance} \
  | jq -r '.Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicDnsName'
}

start ()
{
#  local vm_number="$1"
#  
#  if [ "$1" < "0" ]; then
#    echo "Number of VMs should be more then 1"
#  elif [ "$1" = "1" ]; then 

#  start_log=$(
    start_vm 10.3.1.61 associate-public-ip ${USER_NAME}-vm1 >> ~/start_log
#  )
  sleep 5s

  instance_id=$( cat ~/start_log | jq -r .Instances[0].InstanceId)

#  else
#    for i in {2..2}; do
#      start_vm 10.3.1.$((60+i)) no-associate-public-ip-address ${USER_NAME}-vm$i > /dev/null
#    done

  sleep 10s
  dns_name=$(get_dns_name "$instance_id")
  echo $dns_name

#fi
}

stop()
{
  ids=($(
    aws ec2 describe-instances \
    --query 'Reservations[*].Instances[?KeyName==`'$KEY_NAME'`].InstanceId' \
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

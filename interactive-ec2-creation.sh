#!/bin/bash

# Prompt the user for the required parameters.
echo "Please provide the region you want to set up the EC2 machine in."
read REGION
REGION=$REGION

echo "Please provide the ID of the AMI you would like to use. (Please take care to look up the ID from the region you want to set up the EC2 machine in.)"
read AMI_ID
AMI_ID=$AMI_ID

echo "Please provide the instance type you want to use."
read INSTANCE_TYPE
INSTANCE_TYPE=$INSTANCE_TYPE

echo "Please provide the name of the key you want to use."
read KEY_NAME
KEY_NAME=$KEY_NAME

echo "Please provide the NAME of the security group you want to use. (not the ID)"
read SECURITY_GROUP
SECURITY_GROUP=$SECURITY_GROUP

# Launch the EC2 instance
aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-groups $SECURITY_GROUP \
  --region $REGION

# Print the instance ID
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=key-name,Values=$KEY_NAME" --query 'Reservations[].Instances[].InstanceId' --output text)
echo "Instance ID: $INSTANCE_ID"

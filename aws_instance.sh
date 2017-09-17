#!/bin/sh
# this script is provided as-is with no warranty implied or expressed.
#
# 
# ensure "jq" is installed. 
# refer https://stedolan.github.io/jq/download/
#

function usage() {
  echo "$0 (start|stop|status)"
}

if [ $# -ne 1 ]; then
  usage
  exit 2
fi

DEBUG="echo "
DEBUG=""

REGION=undefined

INSTANCE_ID=i-undefined

INSTANCE_DETAILS=`aws ec2 describe-instances --region $REGION --filters "Name=instance-id,Values=$INSTANCE_ID"`

INSTANCE_IP=`echo $INSTANCE_DETAILS| jq -r '.Reservations[].Instances[].PublicIpAddress'`
INSTANCE_STS=`echo $INSTANCE_DETAILS| jq -r '.Reservations[].Instances[].State.Name'`
INSTANCE_NAME=`echo $INSTANCE_DETAILS| jq -r '.Reservations[].Instances[].Tags[].Value'`

echo "Instances : [$INSTANCE_ID] [$INSTANCE_IP] [$INSTANCE_STS] [$INSTANCE_NAME]"


EXIT=0
if [ "$1" = "start" ]; then
  if [ "$INSTANCE_STS" = "running" ]; then
    echo "instance is already running."
  else
    echo "start instance..."
    $DEBUG aws ec2 start-instances --instance-ids $INSTANCE_ID --region $REGION
    EXIT=$?
  fi
elif [ "$1" = "stop" ]; then
  if [ "$INSTANCE_STS" = "running" ]; then
    echo "stop instance..."
    $DEBUG aws ec2 stop-instances --instance-ids $INSTANCE_ID --region $REGION
    EXIT=$?
  else
    echo "instance is already stopped."
  fi
elif [ "$1" = "status" ]; then
  echo "Status Check only."
else
  usage
  EXIT=2
fi

exit $EXIT
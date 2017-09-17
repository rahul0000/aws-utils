#!/bin/bash

#this script is provided as-is with no warranty implied or expressed.

#Use at your own risk!

DEBUG="echo "
DEBUG=""

 
CURDATE=`date +%Y%m%d-%H%M`

REGION=undefined
REF_IMAGE_NAME=ref-image-name-undefined
NEW_REF_IMAGE_NAME=ref-image-name-$CURDATE

# new Launch Config name
CLUSTER_LC_NAME=CLUSTER-lc-$CURDATE
# Security Group for cluster
SG_ID=sg-undefined
# AUTO Scale Group
ASG_NAME=asg-undefined

 
## Get current instance ID:
CLUSTERID=`ec2-describe-instances --region=$REGION|grep -i $REF_IMAGE_NAME |awk '{ print $3 }'`
echo "Current CLUSTER AMI: ${CLUSTERID}"
 
#snapshot the instance without rebooting
NEWAMI=`ec2-create-image $CLUSTERID \
     --no-reboot \
     --region=$REGION \
     --name "$NEW_REF_IMAGE_NAME" \
     |awk '{ print $2 }'`
 
#Create launch config for this new AMI
as-create-launch-config CLUSTER_LC_NAME \
     --image-id $NEWAMI \
     --region=$REGION \
     --instance-type t2.micro \
     --group $SG_ID \
     --user-data "created by CLUSTER-asgroup"
 
#wait for the image to not be pending (this command will not show anything until the image is complete!)
TESTVAR=`ec2-describe-images --region=$REGION |grep pending |wc -l |awk '{ print $1 }'`
sleep 10
 
#
until [[ ${TESTVAR} = "0" ]]; do
 
        TESTVAR=`ec2-describe-images --region=$REGION |grep pending |wc -l |awk '{ print $1 }'`
        echo "Checking if the AMI snapshot is completed..."
        sleep 20
 
done
 
#update autoscaling group:
as-update-auto-scaling-group $ASG_NAME --region=$REGION \
     --launch-configuration $CLUSTER_LC_NAME
 
 
FNR=`ec2-describe-instances --region=$REGION |grep "$ASG_NAME"|awk '{ print $3 }'`
echo "Please wait up to 10 minutes for this section to complete! Seriously. Ten of them."
 
for i in $FNR; do
 
        as-set-instance-health $i --status Unhealthy --region=$REGION --no-respect-grace-period
        echo "Sleeping for two minutes, please don't cancel this script..."
        sleep 120
        until [[ `as-describe-scaling-activities --region=$REGION |grep InProgress \
             |wc -l |awk '{ print $1 }'` == "0" ]]; do
 
                echo "Waiting for new instance to finish deploying."
                sleep 10
 
        done
done


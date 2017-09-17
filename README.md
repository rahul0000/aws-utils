# aws-utils
Collection of simple everyday use command

# Setup

In order to use AWS via command line basic AWS client sdk install is required.

** Refer: **

> http://www.dowdandassociates.com/blog/content/howto-install-aws-cli-amazon-auto-scaling/
> http://www.dowdandassociates.com/blog/content/howto-use-aws-autoscaling-api-to-deploy-high-availability-clusters/

** Setup path and passwords **
> In ~/.profile add

```
# AWS Credentials
[[ -f ~/.bash_aws ]] && . ~/.bash_aws
export AWS_ELB_HOME=/opt/aws/ElasticLoadBalancing
export PATH=$PATH:$AWS_ELB_HOME/bin
export AWS_AUTO_SCALING_HOME=/opt/aws/AutoScaling
export EC2_HOME=/opt/aws/ec2-api-tools
export PATH=$PATH:$AWS_AUTO_SCALING_HOME/bin:$EC2_HOME/bin
export JAVA_HOME=$(/usr/libexec/java_home)
export AWS_CREDENTIAL_FILE=~/.aws/aws_credential_file
```

> create directory and file 
> add text
```
mkdir -p ~/.aws/
 vi ~/.aws/aws_credential_file

AWSAccessKeyId=xxxxxxxxxxx
AWSSecretKey=yyyyyyyyyyyyyy
```

** create file and add **
> vi ~/.bash_aws

```
export AWS_ACCESS_KEY_ID=xxxxxxxxxxx
export AWS_SECRET_KEY=yyyyyyyyyyyyyy
export AWS_SECRET_ACCESS_KEY=yyyyyyyyyyyyyy
export AWS_ACCESS_KEY=xxxxxxxxxxx

# region
export EC2_URL=https://ec2.ap-south-1.amazonaws.com
```


** Test - execute these on command line **
```
ec2-describe-instances
as-describe-auto-scaling-groups --region ap-south-1
```


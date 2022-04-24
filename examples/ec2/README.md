Terraform sample
===

## Overview
簡単なWebサーバを作るサンプル

## Install
- install tfenv
  1. tfenv install 0.12.5
  2. tfenv use 0.12.5
  3. tfenv list

- install aws cli

## Usage
1. aws configure to set up AWS Configure with AccessKey and Secret Key
2. Confirm AWS connectivity
  - aws sts get-caller-identity
3. terraform init
4. terraform plan
5. terraform apply
6. login with key pair
- amazon linux
ssh -i "/Users/yas/Credential/log-ec2-linux-keypair.pem" ec2-user@{public_dns}
- centos
ssh -i "/Users/yas/Credential/log-ec2-linux-keypair.pem" centos@{public_dns}

## Ref
- Search AMI ID for OS
aws ec2 describe-images --owners aws-marketplace       --filters "Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce"       --query "reverse(sort_by(Images, &CreationDate))[0].[ImageId,CreationDate,Description]"       --output text &
  - [CentOS AMI](https://wiki.centos.org/Cloud/AWS)
  - [Ubuntsu AMI](https://cloud-images.ubuntu.com/locator/ec2/)

## Cleanup
terraform destroy

## Licence

## Author
[y-shigeta](https://github.com/y-shigeta)

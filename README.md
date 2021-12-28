Terraform sample
===

## Overview

This is how to use Terraform for AWS and GCP. 
[terraform AWS guide](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
[terraform GCP guide](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

## Description

## Principal
- Simple is best
- 疎結合
- 同じタイミング・理由で変更するモジュールはまとめる
- 認知的負荷を下げる（必須項目は少なくし可能な限りOptionにする）
- フォルダ構成・ファイル名はこれらを意識して配置する
- セマンティックVersioningを採用する。X（Major Verup）.Y（機能追加）.Z（BugFix）で記載
- 呼び出し側でVersion制約を設ける。
- Teraform Module Registoryを活用する。命名規則に沿い、Githubに公開する
- コンポーネント分割を行う。更新頻度度、データを扱うモジュール、ビジネス影響範囲、依存関係は少なく
- Credentialをクラウド内に閉じ込めれば、Terraformの実行権限をロールで管理できる。

## Install
- install tfenv
  1. tfenv install 0.12.5
  2. tfenv use 0.12.5
  3. tfenv list

- install aws cli

- install terraformer (import to terraform from instance created manually)
1. brew install terraformer
2. Provider定義
3. terraform init
4. terraformer import aws --regions=us-west-1 --resources=vpc --filter=aws_vpc=vpc-xxx

## Preparation
- terraform 環境分離(環境ごとにtfstateファイルを分離して使う)
terraform workspace dev
terraform workspace prd
terraform workspace select dev
terraform workspace list

- CICD pipeline
1. get github token
2. store github token into SSM parameter
aws ssm put-parameter --type SecureString --name /continuous_apply/github_token --value <yourgithubtoken>


- Search AMI ID for OS
aws ec2 describe-images --owners aws-marketplace       --filters "Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce"       --query "reverse(sort_by(Images, &CreationDate))[0].[ImageId,CreationDate,Description]"       --output text &
  - [CentOS AMI](https://wiki.centos.org/Cloud/AWS)
  - [Ubuntsu AMI](https://cloud-images.ubuntu.com/locator/ec2/)

## Usage
- AWS preparation
  1. aws configure to set up AWS Configure with AccessKey and Secret Key
  2. Confirm AWS connectivity
    - aws sts get-caller-identity
  3. terraform init
  4. terraform plan
  5. terraform apply
  6. login with key pair
  - ssh -i "/Users/yas/Credential/ec2-linux-keypair.pem" ec2-user@ec2-54-183-53-250.us-west-1.compute.amazonaws.com

- GCP preparation

## Cleanup

## Licence

## Author
[y-shigeta](https://github.com/y-shigeta)
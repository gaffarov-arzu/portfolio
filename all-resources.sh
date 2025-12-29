#!/bin/bash

# Kaynak tiplerini listeliyoruz
resources=(
"EC2 Instances"
"S3 Buckets"
"RDS Instances"
"Lambda Functions"
"VPCs"
"EFS File Systems"
"EKS Clusters"
"SNS Topics"
"SQS Queues"
"IAM Users"
)

echo "AWS Kaynak Tipleri:"
for i in "${!resources[@]}"; do
  echo "$((i+1))) ${resources[$i]}"
done

# Kullanıcıdan seçim al (tek veya birden fazla)
read -p "Bir veya birden fazla kaynak seçin (numaraları boşlukla girin, örn: 1 3 4): " choices

# AWS bölgelerini al
regions=($(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text))

# Seçilen her kaynak için tüm bölgelerde arama
for choice in $choices; do
  resource=${resources[$((choice-1))]}
  echo ""
  echo "================= RESOURCE: $resource ================="

  case $resource in

    "EC2 Instances")
      for region in "${regions[@]}"; do
        instances=$(aws ec2 describe-instances --region $region \
          --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PublicIpAddress,Tags[?Key==`Name`].Value|[0]]' \
          --output json)
        if [[ "$instances" != "[]" ]]; then
          echo "---- REGION: $region ----"
          echo "$instances" | jq -r '.[][] | "InstanceId: \(. [0]), State: \(. [1]), Type: \(. [2]), Public IP: \(. [3]), Name: \(. [4])"'
        fi
      done
      ;;

    "S3 Buckets")
      buckets=$(aws s3api list-buckets --query 'Buckets[*].[Name,CreationDate]' --output json)
      if [[ "$buckets" != "[]" ]]; then
        echo "---- Global (S3) ----"
        echo "$buckets" | jq -r '.[] | "Name: \(. [0]), CreationDate: \(. [1])"'
      fi
      ;;

    "RDS Instances")
      for region in "${regions[@]}"; do
        rds=$(aws rds describe-db-instances --region $region \
          --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,DBInstanceStatus,Endpoint.Address]' \
          --output json)
        if [[ "$rds" != "[]" ]]; then
          echo "---- REGION: $region ----"
          echo "$rds" | jq -r '.[][] | "DBInstanceId: \(. [0]), Class: \(. [1]), Engine: \(. [2]), Status: \(. [3]), Endpoint: \(. [4])"'
        fi
      done
      ;;

    "Lambda Functions")
      for region in "${regions[@]}"; do
        lambdas=$(aws lambda list-functions --region $region \
          --query 'Functions[*].[FunctionName,Runtime,Handler,LastModified]' \
          --output json)
        if [[ "$lambdas" != "[]" ]]; then
          echo "---- REGION: $region ----"
          echo "$lambdas" | jq -r '.[][] | "Function: \(. [0]), Runtime: \(. [1]), Handler: \(. [2]), LastModified: \(. [3])"'
        fi
      done
      ;;

    "VPCs")
      for region in "${regions[@]}"; do
        vpcs=$(aws ec2 describe-vpcs --region $region \
          --query 'Vpcs[*].[VpcId,CidrBlock,State,IsDefault]' \
          --output json)
        if [[ "$vpcs" != "[]" ]]; then
          echo "---- REGION: $region ----"
          echo "$vpcs" | jq -r '.[][] | "VpcId: \(. [0]), CIDR: \(. [1]), State: \(. [2]), IsDefault: \(. [3])"'
        fi
      done
      ;;

    "EFS File Systems")
      for region in "${regions[@]}"; do
        efs=$(aws efs describe-file-systems --region $region \
          --query 'FileSystems[*].[FileSystemId,LifeCycleState,Name]' \
          --output json)
        if [[ "$efs" != "[]" ]]; then
          echo "---- REGION: $region ----"
          echo "$efs" | jq -r '.[][] | "FileSystemId: \(. [0]), State: \(. [1]), Name: \(. [2])"'
        fi
      done
      ;;

    "EKS Clusters")
      for region in "${regions[@]}"; do
        eks_clusters=$(aws eks list-clusters --region $region --query 'clusters' --output text)
        if [[ -n "$eks_clusters" ]]; then
          echo "---- REGION: $region ----"
          for cluster in $eks_clusters; do
            aws eks describe-cluster --region $region --name $cluster \
              --query 'cluster.[name,status,endpoint,platformVersion]' --output json \
              | jq -r '.[][] | "Cluster: \(. [0]), Status: \(. [1]), Endpoint: \(. [2]), Version: \(. [3])"'
          done
        fi
      done
      ;;

    "SNS Topics")
      for region in "${regions[@]}"; do
        topics=$(aws sns list-topics --region $region --query 'Topics[*].TopicArn' --output json)
        if [[ "$topics" != "[]" ]]; then
          echo "---- REGION: $region ----"
          echo "$topics" | jq -r '.[] | "TopicArn: \(. )"'
        fi
      done
      ;;

    "SQS Queues")
      for region in "${regions[@]}"; do
        queues=$(aws sqs list-queues --region $region --query 'QueueUrls' --output json)
        if [[ "$queues" != "[]" ]]; then
          echo "---- REGION: $region ----"
          echo "$queues" | jq -r '.[] | "QueueUrl: \(. )"'
        fi
      done
      ;;

    "IAM Users")
      users=$(aws iam list-users --query 'Users[*].[UserName,UserId,CreateDate]' --output json)
      if [[ "$users" != "[]" ]]; then
        echo "---- Global (IAM) ----"
        echo "$users" | jq -r '.[] | "UserName: \(. [0]), UserId: \(. [1]), CreateDate: \(. [2])"'
      fi
      ;;

    *)
      echo "Bilinmeyen kaynak: $resource"
      ;;
  esac
done

echo ""
echo "========== Arama tamamlandı =========="

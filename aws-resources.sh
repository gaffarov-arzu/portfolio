#!/bin/bash

# Tüm AWS bölgelerini al
regions=($(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text))

echo "AWS Bölgeleri:"
for i in "${!regions[@]}"; do
  echo "$((i+1))) ${regions[$i]}"
done
echo "a) Hepsini göster"

# Kullanıcıdan seçim al (birden fazla numara veya 'a' hepsini göstermek için)
read -p "Bir veya birden fazla bölge seçin (numaraları boşlukla girin, örn: 1 3 4 veya a): " choices

# Seçilen bölgeleri işleme
if [[ "$choices" == "a" || "$choices" == "A" ]]; then
  selected_regions=("${regions[@]}")
else
  selected_regions=()
  for choice in $choices; do
    if [[ $choice -lt 1 || $choice -gt ${#regions[@]} ]]; then
      echo "Geçersiz seçim: $choice"
      continue
    fi
    selected_regions+=("${regions[$((choice-1))]}")
  done
fi

# Seçilen her bölge için tarama
for region in "${selected_regions[@]}"; do
  echo ""
  echo "================= REGION: $region ================="

  echo "---------- EC2 Instances ----------"
  aws ec2 describe-instances --region $region \
    --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PublicIpAddress,Tags[?Key==`Name`].Value|[0]]' \
    --output table

  echo "---------- RDS Instances ----------"
  aws rds describe-db-instances --region $region \
    --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,DBInstanceStatus,Endpoint.Address]' \
    --output table

  echo "---------- Lambda Functions ----------"
  aws lambda list-functions --region $region \
    --query 'Functions[*].[FunctionName,Runtime,Handler,LastModified]' \
    --output table

  echo "---------- VPCs ----------"
  aws ec2 describe-vpcs --region $region \
    --query 'Vpcs[*].[VpcId,CidrBlock,State,IsDefault]' \
    --output table

  echo "---------- EFS File Systems ----------"
  aws efs describe-file-systems --region $region \
    --query 'FileSystems[*].[FileSystemId,LifeCycleState,Name]' \
    --output table

  echo "---------- EKS Clusters ----------"
  eks_clusters=$(aws eks list-clusters --region $region --query 'clusters' --output text)
  if [ -z "$eks_clusters" ]; then
    echo "No EKS clusters found"
  else
    for cluster in $eks_clusters; do
      aws eks describe-cluster --region $region --name $cluster \
        --query 'cluster.[name,status,endpoint,platformVersion]' --output table
    done
  fi

  echo "---------- SNS Topics ----------"
  aws sns list-topics --region $region \
    --query 'Topics[*].TopicArn' \
    --output table

  echo "---------- SQS Queues ----------"
  aws sqs list-queues --region $region \
    --query 'QueueUrls' \
    --output table
done

# S3 bucket’lar globaldir
echo ""
echo "---------- S3 Buckets (Global) ----------"
aws s3api list-buckets \
  --query 'Buckets[*].[Name,CreationDate]' \
  --output table

# IAM kullanıcılar globaldir
echo ""
echo "---------- IAM Users (Global) ----------"
aws iam list-users \
  --query 'Users[*].[UserName,UserId,CreateDate]' \
  --output table

echo ""
echo "========== Tarama tamamlandı =========="

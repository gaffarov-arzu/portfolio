# butun regionlarda subnetleri gormek
```bash
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
  echo "Region: $region"
  aws ec2 describe-subnets --region $region \
    --query "Subnets[*].[SubnetId,VpcId,CidrBlock,AvailabilityZone]" \
    --output table
done
```

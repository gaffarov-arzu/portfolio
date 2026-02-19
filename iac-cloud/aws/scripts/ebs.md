# asagidaki script awsde elastic block storageleri verir
```bash
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    echo "Region: $region"
    aws ec2 describe-volumes --region $region \
        --query "Volumes[*].[VolumeId,Size,VolumeType,State,Attachments[0].InstanceId]" \
        --output table
    echo "--------------------------------------"
done
```

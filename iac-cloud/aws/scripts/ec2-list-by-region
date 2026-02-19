# asagidaki script butun regionlarda olan ec2 lari siyahilasdirir
```bash
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    count=$(aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].InstanceId" --output text | wc -w)
    echo "$region: $count"
done
```

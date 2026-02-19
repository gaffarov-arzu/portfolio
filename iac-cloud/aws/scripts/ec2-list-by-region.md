# asagidaki script butun regionlarda olan ec2 lari siyahilasdirir tipini verir ve umumi sayini verir
```bash
total=0
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    # Instance ID'leri al ve satır bazında say
    instance_ids=$(aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].InstanceId" --output text)
    count=$(echo "$instance_ids" | tr '\t' '\n' | grep -c .)  # boş satırları sayma
    echo "$region: $count instance"
    if [ "$count" -gt 0 ]; then
        aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[InstanceId,InstanceType]" --output table
    fi
    total=$((total + count))
done
echo "Total EC2 instances across all regions: $total"

```

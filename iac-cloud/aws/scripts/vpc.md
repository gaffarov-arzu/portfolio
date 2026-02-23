# awste butun regionlardaki vpclerin siyahisi ucun script
```bash
total=0

for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    vpc_ids=$(aws ec2 describe-vpcs --region $region --query "Vpcs[*].VpcId" --output text)

    count=$(echo "$vpc_ids" | tr '\t' '\n' | grep -c .)

    echo "$region: $count vpc"

    if [ "$count" -gt 0 ]; then
        aws ec2 describe-vpcs --region $region \
          --query "Vpcs[*].[VpcId,CidrBlock,IsDefault]" \
          --output table
    fi

    total=$((total + count))
done

echo "Total VPCs across all regions: $total"
```

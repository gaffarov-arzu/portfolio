# asagidaki script awsde butun regionlarda rdslarin siyahisini tipini verir
```bash
regions=$(aws ec2 describe-regions --query "Regions[*].RegionName" --output text)
for region in $regions; do
    echo "Region: $region"
    for db in $(aws rds describe-db-instances --region $region --query "DBInstances[*].DBInstanceIdentifier" --output text); do
        echo "RDS Instance: $db"
        aws rds describe-db-instances \
            --region $region \
            --db-instance-identifier $db \
            --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,MultiAZ,AllocatedStorage,StorageType]" \
            --output table
        echo "--------------------------------------"
    done
done

```

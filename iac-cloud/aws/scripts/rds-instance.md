# asagidaki script awsde rdslarin siyahisini tipini verir
```bash
for db in $(aws rds describe-db-instances --query "DBInstances[*].DBInstanceIdentifier" --output text); do
    echo "RDS Instance: $db"
    aws rds describe-db-instances \
        --db-instance-identifier $db \
        --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,MultiAZ,AllocatedStorage,StorageType]" \
        --output table
    echo "--------------------------------------"
done
```

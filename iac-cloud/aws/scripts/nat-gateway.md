# awsde nat gatewaylari siyahilasdirir butun regionlar ucun
```bash
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    echo "Region: $region"
    aws ec2 describe-nat-gateways \
        --region $region \
        --query "NatGateways[*].[NatGatewayId,VpcId,State,SubnetId,ConnectivityType]" \
        --output table
    echo "--------------------------------------"
done

```

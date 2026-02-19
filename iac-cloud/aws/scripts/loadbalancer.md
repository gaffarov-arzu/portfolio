# asagidaki script butun regionlarda loadbalanceri getirir
```bash
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    echo "Region: $region"
    echo "Load Balancers:"
    aws elbv2 describe-load-balancers \
        --region $region \
        --query "LoadBalancers[*].[LoadBalancerName,Scheme,Type,DNSName,State.Code]" \
        --output table
    echo "--------------------------------------"
done
```

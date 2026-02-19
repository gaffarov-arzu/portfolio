# awsde her tip lb-ni regiona gore verir hem classic hem de diger loadbalancerleri
```bash
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    echo "Region: $region"
    
    # Classic Load Balancer (ELB v1)
    clb_count=$(aws elb describe-load-balancers --region $region --query "length(LoadBalancerDescriptions)" --output text 2>/dev/null)
    if [ "$clb_count" != "0" ] && [ "$clb_count" != "None" ]; then
        echo "Classic Load Balancers ($clb_count):"
        aws elb describe-load-balancers \
            --region $region \
            --query "LoadBalancerDescriptions[*].[LoadBalancerName,DNSName,VPCId,AvailabilityZones,Scheme]" \
            --output table
    else
        echo "No Classic Load Balancers in this region or insufficient permissions."
    fi
    
    # Application / Network / Gateway Load Balancers (ELB v2)
    alb_count=$(aws elbv2 describe-load-balancers --region $region --query "length(LoadBalancers)" --output text 2>/dev/null)
    if [ "$alb_count" != "0" ] && [ "$alb_count" != "None" ]; then
        echo "ALB/NLB/Gateway Load Balancers ($alb_count):"
        aws elbv2 describe-load-balancers \
            --region $region \
            --query "LoadBalancers[*].[LoadBalancerName,Scheme,Type,DNSName,State.Code,AvailabilityZones[*].ZoneName]" \
            --output table
    else
        echo "No ALB/NLB/Gateway Load Balancers in this region or insufficient permissions."
    fi
    
    echo "--------------------------------------"
done
```

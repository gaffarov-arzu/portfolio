# awsde nat gatewaylari siyahilasdirir
```bash
echo "NAT Gateways:"
aws ec2 describe-nat-gateways \
    --query "NatGateways[*].[NatGatewayId,VpcId,State,SubnetId,ConnectivityType]" \
    --output table
echo "--------------------------------------"
```

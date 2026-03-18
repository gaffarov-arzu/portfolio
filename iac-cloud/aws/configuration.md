# Konfiqurasya
```bash
aws --version
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws configure
```

# instancelerin siyahisi seliqeli sekilde
```bash
aws ec2 describe-instances   --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]'   --output table
```

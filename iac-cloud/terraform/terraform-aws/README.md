
# AWS Infrastructure with Terraform

Production-ready AWS infrastructure using reusable Terraform modules.

## Architecture

![Architecture](https://via.placeholder.com/800x400?text=VPC+%2B+EC2+%2B+RDS+%2B+S3)

## Modules

| Module | Description |
|--------|-------------|
| vpc    | VPC, public/private subnets, IGW, route tables |
| ec2    | EC2 instance, security group |
| s3     | S3 bucket, versioning, encryption |
| rds    | MySQL 8.0, subnet group, security group |
| alb    | Application Load Balancer (planned) |

## Usage
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Environment Variables
```bash
export TF_VAR_db_password="your-password"
```

## Notes

- All modules are reusable and environment-agnostic
- ALB module written but commented out for cost optimization
- Sensitive values never committed to version control

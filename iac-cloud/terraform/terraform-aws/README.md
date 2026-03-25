# AWS Infrastructure with Terraform

Production-ready AWS infrastructure using reusable Terraform modules.

## Architecture

```
Internet
    │
    ▼
Application Load Balancer (public, multi-AZ)
    │
    ▼
EC2 t2.micro (us-east-1a, IAM role attached)
    │
    ├── S3 Bucket (versioning + AES256 encryption)
    │
    └── RDS MySQL 5.7 (private subnet, db.t2.micro)

NAT Gateway (public subnet) → private subnets → internet
```

## Project Structure

```
terraform-aws/
├── environments/
│   ├── bootstrap/          # Run once — creates S3 state bucket + DynamoDB lock table
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
└── modules/
    ├── vpc/                # VPC, public/private subnets, IGW, route tables
    ├── ec2/                # EC2 instance, security group, IAM instance profile
    ├── s3/                 # S3 bucket, versioning, AES256 encryption
    ├── rds/                # MySQL 5.7, subnet group, security group
    ├── alb/                # ALB, target group, listener, EC2 attachment
    ├── iam/                # IAM role, S3 + CloudWatch policy, instance profile
    └── nat/                # NAT Gateway, Elastic IP, private route table
```

## Remote State

State is stored in S3 with DynamoDB locking for team-safe operations.

**Step 1 — Bootstrap (run once):**
```bash
cd environments/bootstrap
terraform init
terraform apply
```
This creates:
- S3 bucket: `ieltsfly-terraform-state` (versioning + encryption enabled)
- DynamoDB table: `ieltsfly-terraform-locks` (LockID partition key)

**Step 2 — Deploy infrastructure:**
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Usage

```bash
# Set sensitive values via environment variable — never commit to tfvars
export TF_VAR_db_password="your-password"

cd environments/dev
terraform init
terraform plan
terraform apply
```

## Modules

| Module | Resources | Description |
|--------|-----------|-------------|
| vpc    | aws_vpc, aws_subnet (x4), aws_internet_gateway, aws_route_table | Network foundation |
| ec2    | aws_instance, aws_security_group | Web server, IAM profile attached |
| s3     | aws_s3_bucket, versioning, encryption, public_access_block | File storage |
| rds    | aws_db_instance, aws_db_subnet_group, aws_security_group | MySQL database (private subnet) |
| alb    | aws_lb, aws_lb_target_group, aws_lb_listener, aws_lb_target_group_attachment | Load balancer → EC2 |
| iam    | aws_iam_role, aws_iam_role_policy, aws_iam_instance_profile | EC2 permissions for S3 + CloudWatch |
| nat    | aws_nat_gateway, aws_eip, aws_route_table | Private subnet internet access |

## Traffic Flow

```
User → ALB DNS → ALB → Target Group → EC2 (port 80)
EC2  → IAM Role → S3 (no credentials needed)
EC2  → IAM Role → CloudWatch (logs + metrics)
RDS  → NAT Gateway → Internet (patches/updates)
```

## Cost Estimate (us-east-1)

| Resource | Type | Cost |
|----------|------|------|
| EC2 | t2.micro | Free tier (750h/mo) |
| RDS | db.t2.micro MySQL 5.7 | Free tier (750h/mo, 12 months) |
| S3 | Standard | Free tier (5GB) |
| ALB | Application | ~$6/month |
| NAT Gateway | — | ~$32/month |

> **Note:** ALB and NAT Gateway are deployed for demonstration. In a cost-optimized environment, NAT Gateway can be replaced with VPC endpoints for specific AWS services.

## Security Notes

- RDS is in private subnets — no direct internet access
- EC2 security group allows SSH (port 22) and HTTP (port 80) only
- S3 bucket has public access fully blocked
- IAM role follows least-privilege principle (S3 + CloudWatch only)
- Sensitive values (db_password) are never committed to version control
- State file is encrypted at rest in S3

## .gitignore

```
*.tfvars
*.tfstate
*.tfstate.backup
.terraform/
.terraform.lock.hcl
```

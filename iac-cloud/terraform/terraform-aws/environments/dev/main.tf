

terraform {
 backend "s3" {
    bucket         = "ieltsfly-terraform-state-qafarzu"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ieltsfly-terraform-locks-qafarzu"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "../../modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  cidr_block           = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}


module "s3" {
  source       = "../../modules/s3"
  project_name = var.project_name
  environment  = var.environment
}

module "rds" {
  source             = "../../modules/rds"
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids
  instance_class     = var.db_instance_class
  allocated_storage  = var.db_allocated_storage
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
}

 module "alb" {
   source            = "../../modules/alb"
   project_name      = var.project_name
   environment       = var.environment
   vpc_id            = module.vpc.vpc_id
   public_subnet_ids = module.vpc.public_subnet_ids
   ec2_instance_id   = module.ec2.instance_id
 }


module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  bucket_name  = module.s3.bucket_name
}
module "nat" {
  source              = "../../modules/nat"
  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.vpc.public_subnet_ids[0]
  private_subnet_ids  = module.vpc.private_subnet_ids
  internet_gateway_id = module.vpc.internet_gateway_id
}
module "ec2" {
  source               = "../../modules/ec2"
  project_name         = var.project_name
  environment          = var.environment
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = module.vpc.public_subnet_ids[0]
  vpc_id               = module.vpc.vpc_id
  key_name             = var.key_name
  iam_instance_profile = module.iam.instance_profile_name  # bunu ekle
}

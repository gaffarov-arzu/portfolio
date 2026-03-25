variable "aws_region" { default = "us-east-1" }
variable "project_name" {}
variable "environment" {}
variable "vpc_cidr" {}
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "db_instance_class" {}
variable "db_allocated_storage" { type = number }
variable "db_name" {}
variable "db_username" {}
variable "db_password" { sensitive = true }

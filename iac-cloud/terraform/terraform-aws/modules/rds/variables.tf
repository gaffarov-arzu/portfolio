variable "project_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "private_subnet_ids" { type = list(string) }
variable "instance_class" {}
variable "allocated_storage" { type = number }
variable "db_name" {}
variable "db_username" {}
variable "db_password" { sensitive = true }

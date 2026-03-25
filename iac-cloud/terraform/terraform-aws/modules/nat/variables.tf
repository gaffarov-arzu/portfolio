variable "project_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "public_subnet_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "internet_gateway_id" {}

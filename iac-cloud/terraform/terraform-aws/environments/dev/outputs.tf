output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

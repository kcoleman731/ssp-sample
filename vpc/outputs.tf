output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.aws_vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.aws_vpc.private_subnets
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.aws_vpc.public_subnets
}

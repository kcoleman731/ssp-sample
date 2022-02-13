
locals {
  terraform_version = "Terraform v1.0.1"

  tenant      = "kevin" # AWS account name or unique id for tenant
  environment = "prod"  # Environment area eg., preprod or prod
  zone        = "zone"  # Environment with in one sub_tenant or business unit

  vpc_cidr     = "10.0.0.0/16"
  vpc_name     = join("-", [local.tenant, local.environment, local.zone, "vpc"])
  cluster_name = join("-", [local.tenant, local.environment, local.zone, "eks"])
}

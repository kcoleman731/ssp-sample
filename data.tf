data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.eks_cluster_id
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "${path.module}/vpc/local_tf_state/terraform-main.tfstate"
  }
}

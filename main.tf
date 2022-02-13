terraform {
  backend "local" {
    path = "local_tf_state/terraform-main.tfstate"
  }
}

module "eks_cluster" {
  source            = "../aws-eks-accelerator-for-terraform"
  terraform_version = local.terraform_version

  #---------------------------------------------------------------
  # Environment
  #---------------------------------------------------------------

  tenant      = local.tenant
  environment = local.environment
  zone        = local.zone

  #---------------------------------------------------------------
  # Network
  #---------------------------------------------------------------

  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  #---------------------------------------------------------------
  # TEAMS
  #---------------------------------------------------------------

  platform_teams    = local.platform_teams
  application_teams = local.application_teams

  #---------------------------------------------------------------
  # EKS CLUSTER
  #---------------------------------------------------------------

  create_eks          = true
  kubernetes_version  = local.kubernetes_version
  managed_node_groups = local.managed_node_groups
}

module "kubernetes-addons" {
  source = "../aws-eks-accelerator-for-terraform/modules/kubernetes-addons"

  #---------------------------------------------------------------
  # Globals
  #---------------------------------------------------------------

  eks_cluster_id = module.eks_cluster.eks_cluster_id

  #---------------------------------------------------------------
  # EKS MANAGED ADD-ONS
  #---------------------------------------------------------------

  enable_amazon_eks_vpc_cni            = true
  enable_amazon_eks_coredns            = true
  enable_amazon_eks_kube_proxy         = true
  enable_amazon_eks_aws_ebs_csi_driver = true

  #---------------------------------------------------------------
  # ARGO
  #---------------------------------------------------------------

  enable_argocd         = true
  argocd_manage_add_ons = true # Indicates that ArgoCD is responsible for managing/deploying Add-ons.
  argocd_applications = {
    addons    = local.addons
    workloads = local.workloads
  }

  #---------------------------------------------------------------
  # SELF MANAGED ADD-ONS
  #---------------------------------------------------------------

  enable_aws_load_balancer_controller = true
  enable_cluster_autoscaler           = true
  enable_ingress_nginx                = true
  enable_metrics_server               = true
  enable_prometheus                   = true
}
































#   enable_aws_for_fluentbit            = true
#   enable_aws_load_balancer_controller = true
#   enable_cert_manager                 = true
#   enable_cluster_autoscaler           = true
#   enable_ingress_nginx                = true
#   enable_keda                         = true
#   enable_metrics_server               = true
#   enable_spark_k8s_operator           = true
#   enable_traefik                      = true
#   enable_vpa                          = true
#   enable_yunikorn                     = true














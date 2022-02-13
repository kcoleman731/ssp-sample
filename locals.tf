
locals {
  terraform_version = "Terraform v1.0.1"

  #---------------------------------------------------------------
  # Global
  #---------------------------------------------------------------

  tenant      = "ecom"  # AWS account name or unique id for tenant
  environment = "test"  # Environment area eg., preprod or prod
  zone        = "west1" # Environment with in one sub_tenant or business unit

  #---------------------------------------------------------------
  # VPC
  #---------------------------------------------------------------

  vpc_cidr = "10.0.0.0/16"
  vpc_name = join("-", [local.tenant, local.environment, local.zone, "vpc"])

  #---------------------------------------------------------------
  # CLUSTER
  #---------------------------------------------------------------

  kubernetes_version = "1.21"
  cluster_name       = join("-", [local.tenant, local.environment, local.zone, "eks"])

  cluster_domain    = "kcaws.people.aws.dev"
  cluster_subdomain = "prod.${local.cluster_domain}"
  acm_domain        = "*.${local.cluster_subdomain}"

  #---------------------------------------------------------------
  # Node Group
  #---------------------------------------------------------------

  managed_node_groups = {
    mg_4 = {
      node_group_name = "managed-ondemand"
      instance_types  = ["m4.large"]
      desired_size    = 5
      max_size        = 10
      min_size        = 3
      max_unavailable = 1
      subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    }
  }

  #---------------------------------------------------------------
  # ADDONS
  #---------------------------------------------------------------

  addons = {
    path                = "chart"
    target_revision     = "bugfix/update-prometheus-values"
    repo_url            = "git@github.com:aws-samples/ssp-eks-add-ons.git"
    ssh_key_secret_name = "github-ssh-key"
    values              = {}
    add_on_application  = true
  }

  #---------------------------------------------------------------
  # Applications
  #---------------------------------------------------------------

  workloads = {
    path                = "envs/dev"
    target_revision     = "feature/name-update"
    repo_url            = "git@github.com:aws-samples/ssp-eks-workloads.git"
    ssh_key_secret_name = "github-ssh-key"
    values              = {}
  }

  #---------------------------------------------------------------
  # TEAMS
  #---------------------------------------------------------------

  application_teams = {
    coleman = {
      labels = {
        name = "coleman",
      }
      quota = {
        "requests.cpu"    = "2000m",
        "requests.memory" = "8Gi",
        "limits.cpu"      = "4000m",
        "limits.memory"   = "16Gi",
        "pods"            = "20",
        "secrets"         = "20",
        "services"        = "20"
      }
      manifests_dir = "./manifests"
      users = [
        "arn:aws:iam::115717706081:user/eks-admin",
        "arn:aws:iam::115717706081:role/Admin"
      ]
    }
  }

  platform_teams = {
    admin-team-name-example = {
      users = [
        "arn:aws:iam::115717706081:user/eks-admin",
        "arn:aws:iam::115717706081:role/Admin"
      ]
    }
  }
}














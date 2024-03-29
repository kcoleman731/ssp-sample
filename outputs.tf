output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${data.aws_region.current.id} update-kubeconfig --name ${module.eks_cluster.eks_cluster_id}"
}
// output "teams" {
//   description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
//   value       = "Teams: ${jsonencode(module.aws-eks-accelerator-for-terraform.teams)}"
// }


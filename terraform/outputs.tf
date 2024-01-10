output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.eks-vpc.vpc_id
}

output "cluster_id" {
  description = "The ID of the EKS cluster."
  value       = module.eks.cluster_id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

# output "cluster_status" {
#   description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
#   value       = module.eks.cluster_status
# }

# output "cluster_security_group_id" {
#   description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
#   value       = module.eks.cluster_security_group_id
# }


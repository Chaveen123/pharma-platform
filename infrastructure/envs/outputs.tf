/*output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_endpoint
}*/

/*output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}*/

output "bastion_instance_id" {
  description = "Public IP of the Bastion EC2 instance"
  value       = module.ec2.bastion_instance_id
}
/*output "eso_role_arn" {
  description = "ARN of the External Secrets Operator IAM role"
  value       = aws_iam_role.eso_role.arn
}

output "argocd_role_arn" {
  description = "ARN of the ArgoCD IAM role"
  value       = aws_iam_role.argocd_role.arn
}

output "gitlab_runner_role_arn" {
  description = "ARN of the GitLab Runner IAM role"
  value       = aws_iam_role.gitlab_runner_role.arn
}

output "jenkins_role_arn" {
  description = "ARN of the Jenkins IAM role"
  value       = aws_iam_role.jenkins_role.arn
}*/

output "bastion_role_arn" {
  description = "ARN of the Bastion IAM role"
  value       = aws_iam_role.bastion_role.arn
}

output "bastion_instance_profile_name" {
  description = "The name of the bastion IAM instance profile"
  value       = aws_iam_instance_profile.bastion_instance_profile.name
}


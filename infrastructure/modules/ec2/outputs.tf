output "bastion_instance_id" {
  description = "Public IP of the Bastion EC2 instance"
  value       = aws_instance.bastion.public_ip
}

output "bastion_security_group_id" {
  description = "Security group ID for the Bastion EC2 instance"
  value       = aws_security_group.bastion.id
}

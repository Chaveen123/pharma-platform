variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where bastion will be deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for bastion host"
  type        = string
}

/*variable "my_ip" {
  description = "Your workstation IP for SSH access"
  type        = string
}*/

variable "bastion_ami" {
  description = "AMI ID for bastion EC2 (Amazon Linux 2 recommended)"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key pair name for bastion access"
  type        = string
}

variable "bastion_profile_name" {
  description = "Name of the Bastion IAM instance profile"
  type        = string
}
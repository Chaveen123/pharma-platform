# Security Group for Bastion
resource "aws_security_group" "bastion" {
  name        = "${var.project}-${var.env}-bastion-sg"
  description = "Security group for Bastion EC2 host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from your workstation"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # e.g. "203.0.113.25/32"
  }

  ingress {
    description = "Jenkins access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # or restrict to your IP for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-${var.env}-bastion-sg"
    Env     = var.env
    Project = var.project
  }
}

# Bastion EC2 Instance
resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami          # Amazon Linux 2 AMI ID
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id     # place in a public subnet
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/jenkins.sh")

  iam_instance_profile        = var.bastion_profile_name

  tags = {
    Name    = "${var.project}-${var.env}-bastion"
    Env     = var.env
    Project = var.project
  }
}
data "aws_caller_identity" "current" {}

module "vpc" {
  source = "../modules/vpc"

  project                  = "pharmacy-app"
  env                      = "dev"
  vpc_cidr                 = "10.0.0.0/16"
  public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_eks_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  private_rds_subnet_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]
}

/*module "eks" {
  source = "../modules/eks"

  project            = "pharmacy-app"
  env                = "dev"
  cluster_version    = "1.33"
  subnet_ids         = module.vpc.private_eks_subnet_ids
  bastion_security_group_id = module.ec2.bastion_security_group_id
  node_instance_type = "t3.small"
  desired_capacity   = 2
  min_size           = 2
  max_size           = 3
}*/

/*module "rds" {
  source = "../modules/rds"

  project               = "pharmacy-app"
  env                   = "dev"
  subnet_ids            = module.vpc.private_rds_subnet_ids
  vpc_id                = module.vpc.vpc_id
  eks_security_group_id = module.eks.cluster_security_group_id
  db_name               = "pharmadb"
  db_username           = "pharmaadmin"
  db_password           = var.db_password
}*/

module "ecr" {
  source = "../modules/ecr"

  project = "pharmacy-app"
  env     = "dev"
  repositories = [
    "api-gateway",
    "auth-service",
    "pharma-ui",
    "notification-service",
    "drug-catalog-service"
  ]
}

module "iam" {
  source = "../modules/iam"

  project           = "pharmacy-app"
  env               = "dev"
  aws_account_id    = data.aws_caller_identity.current.account_id
}

/*module "secrets_manager" {
  source = "../modules/secrets-manager"

  project     = "pharmacy-app"
  env         = "dev"
  db_username = "pharmaadmin"
  db_password = var.db_password
  jwt_secret  = var.jwt_secret
}*/

module "ec2" {
  source = "../modules/ec2"

  project          = "pharmacy-app"
  env              = "dev"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
  ssh_key_name     = "DevOps_Test"
  bastion_ami      = "ami-098e39bafa7e7303d"
  bastion_profile_name = module.iam.bastion_instance_profile_name
  #my_ip            = var.my_ip
}

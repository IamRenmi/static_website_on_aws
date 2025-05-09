provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    Project     = "wordpress"
    Environment = var.environment
    Owner       = "renmi13@outlook.com"
  }
}

module "vpc" {
  source         = "../modules/vpc"
  region         = var.region
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  app_subnets    = var.app_subnets
  data_subnets   = var.data_subnets
  subnet_azs     = var.subnet_azs
}

module "security_groups" {
  source          = "../modules/security-groups"
  vpc_id          = module.vpc.vpc_id
  ssh_source_cidr = var.ssh_allowed_cidr
  environment     = var.environment
  tags            = local.common_tags
}

## RDS
module "rds" {
  source            = "../modules/rds"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.data_subnet_ids
  security_group_id = module.security_groups.db_sg_id
  username          = var.db_user 
  password          = var.db_password
  availability_zone = var.db_az
}

## EFS
module "efs" {
  source            = "../modules/efs"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.data_subnet_ids
  security_group_id = module.security_groups.efs_sg_id
}
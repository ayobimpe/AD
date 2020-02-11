provider "aws" {
  region = var.region
}

module "network" {
  source             = "./network"
}

module "touch-dir-service" {
  source   = "./touch-dir-service"
  vpc_id   = module.network.aws_gss_vpc
}

module "ec2-instance" {
  source             = "./ec2-instance"
  security_group_id  = module.network.awsgss_sg
  subnet_id          = module.network.public-subnet
}

module "s3-bucket" {
  source             = "./s3-bucket"
}

module "sec-grp" {
  source             = "./sec-grp"
}

module "ssm" {
  source       = "./ssm"
  kms_key_id   = module.kms.awsgsskey
}

module "kms" {
  source       = "./ssm"
}
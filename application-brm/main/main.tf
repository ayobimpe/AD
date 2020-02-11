provider "aws" {
  region = var.region
}

module "alb" {
  source                 = "git::https://bitbucket.org/kinect-consulting/ec2.git//apptier-alb"
  autoscaling_group_name = module.asg.asg
  albsg                  = module.brm-apptier-secgrp.brm-albsg
  targetgrp              = module.asg.asg
  ssl-cert               = var.ssl-cert
  tfe_env                = var.tfe_env
}

module "asg" {
  source            = "git::https://bitbucket.org/kinect-consulting/ec2.git//apptier-asg"
  target_group_arns = module.alb.target_group_arn
  appinstancesg     = module.brm-apptier-secgrp.appinstancesg
  key_name          = var.key_name
  asg_goldami       = var.asg_goldami
  instanceprofile   = var.instanceprofile
  instance_type     = var.instance_type
  tfe_env           = var.tfe_env
  brm_env           = var.brm_env
}

module "brm-apptier-secgrp" {
  source             = "../brm-apptier-secgrp"
  elb_ingress_ipaddr = var.elb_ingress_ipaddr
  ssh_ingress_ipaddr = var.ssh_ingress_ipaddr
}

module "brm-db-tier" {
  source             = "../brm-db-tier"
  appinstancesg      = module.brm-apptier-secgrp.appinstancesg
  key_name           = var.key_name
  numberofebsvolume  = var.numberofebsvolume
  extravolumeencrypt = var.extravolumeencrypt
  goldami            = var.goldami
  extravolumesize    = var.extravolumesize
  dbinstance_type    = var.dbinstance_type
  tdb_env            = var.tdb_env
  # tdb_env_az1        = var.tdb_env_az1
  # tdb_env_az2        = var.tdb_env_az2
}

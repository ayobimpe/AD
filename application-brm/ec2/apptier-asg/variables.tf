variable "key_name" {
  description="Enter key pair for the EC2 instances"
}

variable "region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "asg_goldami" {
    description= "Enter the ami id to use"
}

variable "instance_type" {
  description = "Enter the instance type to use for Instances launched from ASG"
}

variable "target_group_arns" {}

  
variable "minsize" {
  default = 2
}

variable "maxsize" {
  default = 2
}

variable "desiredinstance" {
  default = 2
}

variable "health_check_type" {
  default = "ELB"
}

variable "health_grace_period" {
  default = 300 
}

variable "asg_tag" {
  default = "App-Server"
}

variable "scaling_adjustment" {
  default = 2
}

variable "adjustment_type"{
  default = "ExactCapacity"
}

variable "scaling_policy_cooldown" {
  default = 300 
}
variable "appinstancesg" {}

variable "instanceprofile" {
    description = "Enter the instance profile name for the launched instance"
}


variable "root_device_name" {
  default = "/dev/sda1"
}

variable "root_device_size" {
  default = 50
}

variable "rootvolumeencrypt" {
  description="Encrypt root volume- true or false"
  default = true
}

variable "extravol_size" {
  default = 100
}

variable "extravol_type" {
  type = string
  default = "gp2"
}

variable "delete_on_termination" {
  default = true
}

variable "extravol_encrypt" {
  description="Encrypt extra volume for instances launched from ASG- true or false"
  default = true 
}

variable "extra_device_name" {
  default = "/dev/xvdb"
}

variable "vpc_id" {
    default = "vpc-0b668e3568331a5f0"
}


variable "trac-env" {
    type = map
    default = {
        tfe-lower          = "tf-lower-test-automation-tfe-us-east"
        tdb-lower          = "tf-lower-test-automation-tdb-us-east"
    }
}
locals {
    tfe_subnets         = [
        "${lookup(var.trac-env, var.tfe_env)}-1a-private-sn",
        "${lookup(var.trac-env, var.tfe_env)}-1b-private-sn"
    ]
    # tdb_subnets        = [
    #     "${lookup(var.trac-env, var.tdb_env)}-1c-private-sn",
    #     "${lookup(var.trac-env, var.tdb_env)}-1d-private-sn"
    # ]
}


variable "tfe_env" {
    type = string
    description = "Options: tfe-lower, tdb-lower"
}

variable "brm_env" {
  description = "Options: prod, dev"
}

variable "env_docs" {
  type        = map
  description = "Options: prod, dev"
  default = {
    prod = "prod"
    dev  = "dev"
  }
}


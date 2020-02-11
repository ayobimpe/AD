variable "region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "azs" {
    type = list
    default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
    default = "14.0.0.0/16" 
}

variable "key_name" {
  description="Enter key pair for the BRM EC2 instances"
}

variable "dbinstance_type" {
  description="Enter instance type for the BRM EC2 instances"
}

variable "instancenumber" {
  default     = 2
  description = "Enter the number of instances to create"
}

variable "eipnumber" {
  default     = 2
  description = "Enter the number of Elastic IP to create"
}

variable "eni-number" {
  default     = 2
  description = "Enter the number of network interface to create"
}

variable "extravolumesize" {
  description = "Enter the desired EBS Volumesize in Gib"
}

variable "numberofebsvolume" {
  description = "Enter the number of EBS volumes to create"
}

variable "letters" {
  default = ["b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]
}

variable "rootvolumeencrypt" {
  description="Encrypt root volume- true or false"
  default = true
}
variable "extravolumeencrypt" {
  description="Encrypt secondary volumes- true or false"
}

variable "brmvolumesize" {
  default = 20
}

variable "volume_type" {
  type = string
  default = "gp2"
}


variable "goldami" {
    description= "Enter the ami id to use"
}


variable "detachextravolume" {
  default = true
}

variable "BRM-DB-sg-tag" {
  default = "BRM-DB-sg"
  
}

variable "brm_protocol" {
  default = "tcp"
}

variable "brm_oracleport" {
  default = 1521
}

variable "sshaccess_port" {
  default = 22
}

variable "brm_key_tag" {
  default = "BRM-kmskey"
}

variable "kms_deletion_in_days" {
  default = 10
}

variable "appinstancesg" {}

variable "vpc_id" {
    default = "vpc-0b668e3568331a5f0"
}

variable "cidr_block1" {
    default = "16.0.2.0/24"
}

variable "cidr_block2" {
    default = "16.0.3.0/24"
}

variable "trac-env" {
    type = map
    default = {
        tfe-lower          = "tf-lower-test-automation-tfe-us-east"
        tdb-lower          = "tf-lower-test-automation-tdb-us-east"
        # tdb-loweraz1       = "tf-lower-test-automation-tdb-us-east"
        # tdb-loweraz2       = "tf-lower-test-automation-tdb-us-east"
    }
}
locals {
    # tfe_subnets         = [
    #     "${lookup(var.trac-env, var.tfe_env)}-1c-private-sn",
    #     "${lookup(var.trac-env, var.tfe_env)}-1d-private-sn"
    # ]
    # tdb_subnet_az1        = [
    #     "${lookup(var.trac-env, var.tdb_env_az1)}-1a-private-sn"
    # ]
    # tdb_subnet_az2        = [
    #     "${lookup(var.trac-env, var.tdb_env_az2)}-1b-private-sn"
    # ]
    tdb_subnets         = [
        "${lookup(var.trac-env, var.tdb_env)}-1a-private-sn",
        "${lookup(var.trac-env, var.tdb_env)}-1b-private-sn"
    ]  
}


variable "tdb_env" {
    type = string
    description = "Options: tfe-lower, tdb-lower"
}

variable "db_tag" {
  default = "BRM-DbInstance${count.index + 1}"
  
}

# variable "tdb_env_az1" {
#     type = string
#     description = "Options: tfe-lower, tdb-lower , tdb-loweraz1, tdb-loweraz2"
# }

# variable "tdb_env_az2" {
#     type = string
#     description = "Options: tfe-lower, tdb-loweraz1, tdb-loweraz2 "
# }

# variable "eni_suffix" {
#   default = 5
# }




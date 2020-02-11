variable "elb_ingress_ipaddr" {
  description = "Enter the source ip-address/cidr-block for the BRM App Load Balancer"
}

variable "ssh_ingress_ipaddr" {
  description = "Enter the SSH ip-address/cidr-block to access the BRM EC2 Application Instances"

}

variable "key_name" {
  # description = "Enter key pair for the BRM EC2 instances"
  default     = "Practical"
}

variable "region" {
  description = "EC2 Region for the VPC"
  default     = "us-east-1"
}


variable "numberofebsvolume" {
  # description = "Enter the number of EBS volumes to create"
  default = 0
}

variable "extravolumeencrypt" {
  # description = "Encrypt secondary volumes- true or false"
  default     = "true"
}


variable "goldami" {
  # description = "Enter the ami id to use for the Database Instances"
  default     = "ami-08b65b1fb1d5bd2f2"
}

variable "extravolumesize" {
  # description = "Enter the desired EBS Volumesize in Gib"
  default = 10
}


variable "asg_goldami" {
  description = "Enter the ami id to use for Autoscaling"
  default     = "ami-08b65b1fb1d5bd2f2"
}

variable "ssl-cert" {
  # description = "Enter the ssl certificate for the App Load Balancer"
  default     = "arn:aws:acm:us-east-1:535407588590:certificate/82527f3a-8b98-455d-a60c-9efa9d473236"
}

variable "instanceprofile" {
  # type        = string
  # description = "Enter the instance profile name for the launched instance"
  default     = "ec2admin"
}
  


variable "instance_type" {
    # description= "Enter the instance type to use for Instances launched from ASG"
    default = "t2.medium"
}

variable "dbinstance_type" {
  # description="Enter instance type for the BRM EC2 instances"
  default = "t2.medium"
}

# variable "tdb_env_az1" {
#     type = string
#     description = "Options: tfe-lower, tdb-lower, tdb-loweraz1, tdb-loweraz2 "
# }

# variable "tdb_env_az2" {
#     type = string
#     description = "Options: tfe-lower,tdb-lower, tdb-loweraz1, tdb-loweraz2 "
# }

variable "tdb_env" {
    type = string
    description = "Options: tfe-lower, tdb-lower"
}

variable "tfe_env" {
    type = string
    description = "Options: tfe-lower, tdb-lower"
}

variable "brm_env" {
  description = "Options: prod, dev"
}
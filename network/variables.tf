variable "region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "vpc_cidr" {
    default = "14.0.0.0/16" 
}

variable "privatesubnet_cidrblocks" {
    type = list 
    default = ["14.0.1.0/24","14.0.2.0/24", "14.0.3.0/24", "14.0.4.0/24"] 
}

variable "publicsubnet_cidrblocks" {
    type = list 
    default = ["14.0.5.0/24","14.0.6.0/24"]
}


variable "cidr_block" {
  default = "0.0.0.0/0"
}

variable "azs" {
    type = list
    default = ["us-east-1a", "us-east-1b"]
}

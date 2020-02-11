variable "region" {
  description = "AWS region where the Active Directory will be deployed (i.e. us-gov-west-1)"
  default = "us-gov-west-1"
}

variable "enable_dns_support" {
    default = true
    }

variable "enable_dns_hostnames" {
    default = false
    }


variable "vpc_cidr" {}


variable "project_name" {}


variable "region" {}



variable "access_key" {}

variable "secret_key" {}

variable "key_name" {}

variable "vpc_cidr" {}


variable "publicsubnet_cidrblocks" {
    type = list 
    default = ["10.4.1.0/24","10.4.2.0/24"] 
}
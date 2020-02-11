
variable "region" {
  description = "AWS region where the Active Directory will be deployed"
  default = {}
}

variable "domain_name" {}

variable "admin_password" {}


variable "dir_type" {
  default     = "MicrosoftAD"
}

variable "dir_computer_ou" {
  default     = "OU=awsgss,DC=awsgss,DC=com"
}

variable "vpc_id" {}
# Availability zones
# variable "az1" {}
# variable "az2" {}

# VPC
variable "vpc_id" {
  default     = "vpc-4e9db334"
}

variable "vpc_cidr" {
    default = "14.0.0.0/16" 
}

variable "subnet_cidrblocks" {
    type = list 
    default = ["172.31.80.0/20","172.31.48.0/20"]
}

variable "domain_name" {
  default     = "corp.notexample.com"
}

variable "admin_password" {
  default     = "Sup3rS3cret"
}

variable "dir_type" {
  default     = "MicrosoftAD"
}

variable "dir_computer_ou" {
  default     = "OU=myapp,DC=myapp,DC=com"
}

variable "ssm_policy" {
  type = list
  default = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore","arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"]
}





# # Access
# variable "trusted_ip_address" {}

# trusted_ip_address  = "1.2.3.4/32"

# variable "domain_dns_ips" {
#   description = "Domain DNS IPs"
#   type        = list
# }


# variable "amazon_dns" {
#   description = "Amazon Provided DNS"
#   default     = ["AmazonProvidedDNS"]
#   type        = list
# }
variable "domain_name" {}

variable "admin_password" {}

variable "dir_computer_ou" {
  default     = "OU=myapp,DC=myapp,DC=com"
}


variable "ssm_policy_arn" {
    type = list
    default = ["arn:aws-us-gov:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws-us-gov:iam::aws:policy/AmazonSSMDirectoryServiceAccess"]
}

variable "kms_key_id" {}
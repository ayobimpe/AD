variable "acl" {
  default = "private"
}

variable "bucket_name" {}

variable "versioning_enabled" {
  default = true
  type    = bool
}

variable "region" {}


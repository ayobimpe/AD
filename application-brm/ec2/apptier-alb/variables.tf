variable "load_balancer_type" {
  default = "application"
}

variable "region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "alb_internal" {
  default = true
}
variable "alb_name" {
  default = "ALB"
}

variable "targetgrp_name" {
  default = "Targetgrp" 
}

variable "healthy_threshold" {
  default = 5 
}

variable "unhealthy_threshold" {
  default = 2
}

variable "healthcheck_interval" {
  default = 30
}

variable "healthcheck_path" {
  default = "/index.html"
}

variable "health_check_timeout" {
  default = 5
}

variable "health_check_matcher" {
  default = "200"
}
variable "httpport"{
  default = "443"
}

variable "httpprotocol" {
  default = "HTTPS"
}

variable "hcport"{
  default = "22"
}

variable "hcprotocol" {
  default = "TCP"
}

variable "routing_action" {
  default = "forward"
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
}

variable "ssl-cert" {
  description = "Enter the ssl certificate for the App Load Balancer"
}


variable "field" {
  default = "path-pattern"
}

variable "field_values" {
  default = "/index.html"
}

variable "albsg" {}

variable "autoscaling_group_name" {}

variable "targetgrp" {}

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
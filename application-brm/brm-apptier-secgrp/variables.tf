variable "region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "appinstancesg_name" {
  default = "BRM-webserversg" 
}

variable "elb_ingress_ipaddr"{
  description= "Enter the source ip-address/cidr-block for the BRM App Load Balancer"
}

variable "ssh_ingress_ipaddr"{
  description= "Enter the SSH ip-address/cidr-block to access the BRM EC2 Application Instances"
}

variable "brm_protocol" {
  default = "tcp"
}

variable "brm_port" {
  default = "443"
}
variable "ssh_port" {
  default = "22"
}

variable "appinstancesg_tag" {
  default = "app-sg" 
}

variable "brm-albsg_tag" {
  default = "BRM-alb-sg" 
}

variable "vpc_id" {
    default = "vpc-0b668e3568331a5f0"
}




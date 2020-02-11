provider "aws" {
 region = var.region
}

# Define the security group for BRM Application EC2 Instance
resource "aws_security_group" "appinstancesg" {
  name = var.appinstancesg_name
  description = "Allow incoming for BRM Application Instance"

  ingress {
    from_port = var.brm_port
    to_port = var.brm_port
    protocol = var.brm_protocol
    cidr_blocks = [var.ssh_ingress_ipaddr]
  }

  ingress {
    from_port = var.ssh_port
    to_port = var.ssh_port
    protocol = var.brm_protocol
    cidr_blocks = ["14.0.0.0/16"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["14.0.0.0/16"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }


  vpc_id = var.vpc_id

  tags = {
    Name = var.appinstancesg_tag
  }
}

# Define the security group for BRM Application Load Balancer
resource "aws_security_group" "brm-albsg"{
  name = "BRM_app_load_balancer"
  description = "Allow https traffic"

  ingress {
    from_port = var.brm_port
    to_port = var.brm_port
    protocol = var.brm_protocol
    cidr_blocks = [var.elb_ingress_ipaddr]
  }


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }

  vpc_id = var.vpc_id
  tags = {
    Name = var.brm-albsg_tag
  }
}


output "brm-albsg" {
  value = aws_security_group.brm-albsg.id
}

output "appinstancesg" {
  value = aws_security_group.appinstancesg.id
}

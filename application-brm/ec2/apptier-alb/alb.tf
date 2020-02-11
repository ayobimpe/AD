provider "aws" {
 region = var.region
}

data "aws_subnet_ids" "tfe-lower" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = local.tfe_subnets
  }
}

#Create Application load balancer
  resource "aws_alb" "alb" {
    name	 = var.alb_name
    load_balancer_type = var.load_balancer_type
    security_groups    = [var.albsg]
    subnets            = tolist(data.aws_subnet_ids.tfe-lower.ids)
    internal           = var.alb_internal
  }

# Create target group for the load balancer
  resource "aws_alb_target_group" "targetgrp" {
	  name	= var.targetgrp_name
    vpc_id = var.vpc_id
	  port	= var.httpport
	  protocol	= var.httpprotocol
	  health_check {
		path = var.healthcheck_path
                port = var.httpport
                protocol = var.httpprotocol
                healthy_threshold = var.healthy_threshold
                unhealthy_threshold = var.unhealthy_threshold
                interval = var.healthcheck_interval
		timeout  = var.health_check_timeout
		matcher  = var.health_check_matcher
          }
  }


#Create Listener for the load balancer
  resource "aws_alb_listener" "alb_listener" {
    load_balancer_arn = aws_alb.alb.arn
    port              = var.httpport
    protocol          = var.httpprotocol
    ssl_policy        = var.ssl_policy
    certificate_arn   = var.ssl-cert
    default_action {
      type             = var.routing_action
      target_group_arn = aws_alb_target_group.targetgrp.arn
    }
  }

# Create Listener rule for the listener to direct the http traffic to
  resource "aws_alb_listener_rule" "listener_rule" {
    depends_on   = ["aws_alb_target_group.targetgrp"]  
    listener_arn = aws_alb_listener.alb_listener.arn 
    action {    
      type             = var.routing_action  
      target_group_arn = aws_alb_target_group.targetgrp.id 
    }   
    condition {    
      field  = var.field    
      values = [var.field_values]
    }
  }


# This will associate the autoscaling group with the load balancer
resource "aws_autoscaling_attachment" "asg-attachment" {
  autoscaling_group_name = var.autoscaling_group_name
  alb_target_group_arn   = aws_alb_target_group.targetgrp.arn
}


output "aws_alb_target_group"{
  value = aws_alb_target_group.targetgrp.arn
}

output "target_group_arn"{
  value = aws_alb_target_group.targetgrp.id
}

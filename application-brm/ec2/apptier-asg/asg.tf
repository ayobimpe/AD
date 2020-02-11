provider "aws" {
 region = var.region
}


data "aws_ssm_parameter" "ami_id" {
  name  = var.env_docs[var.brm_env]
}

data "template_file" "hostscript" {
  template = "${file("${path.module}/webserverhost.sh.tpl")}"
  vars = {
    domain_name = var.asg_tag
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content = data.template_file.hostscript.rendered
  }

  part {
    content = data.aws_ssm_parameter.ami_id.value
  }
}


# Create Launch Template
resource "aws_launch_template" "launch-temp" {
  name = "Launch_Template"
  image_id               = var.asg_goldami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.appinstancesg]
  key_name               = var.key_name
  user_data              = data.template_cloudinit_config.config.rendered
  iam_instance_profile {
    name = var.instanceprofile
  }
}

data "aws_subnet_ids" "tfe-lower" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = local.tfe_subnets
  }
}


#Create Autoscaling group
  resource "aws_autoscaling_group" "asg" {
    launch_template {
      id      = "${aws_launch_template.launch-temp.id}"
      version = "$Latest"
    }
    vpc_zone_identifier = tolist(data.aws_subnet_ids.tfe-lower.ids)
    min_size = var.minsize
    max_size = var.maxsize
    desired_capacity = var.desiredinstance
    target_group_arns = [var.target_group_arns]
    health_check_grace_period = var.health_grace_period
    suspended_processes = ["Terminate"]
    health_check_type = var.health_check_type
    tags = [ {
      key                 = "Name"
      value               = var.asg_tag
      propagate_at_launch = true
   }]
  }


# Create Scaling Policy
  resource "aws_autoscaling_policy" "asgpolicy" {
    name                   = "scalingpolicy"
    scaling_adjustment     = var.scaling_adjustment
    adjustment_type        = var.adjustment_type
    cooldown               = var.scaling_policy_cooldown
    autoscaling_group_name = aws_autoscaling_group.asg.name
  }


output "asg" {
  value = aws_autoscaling_group.asg.name
}
/**
* # alert-email
*
* A Terraform module to create an Email-Alert based on a Cloud-Watch Alarm 
*
*
* ## Usage example
*
* ```hcl
* module "alert-email" {
*   source               = "<repo-url>/terraform-modules/cloudwatch.git//alert-email"
*  name                  = "SimplQueueAlert"
*  comparison_operator   = "GreaterThanThreshold"
*  evaluation_periods    = "2"
*  metric_name           = "NumberOfMessagesSent"
*  dimensions            = { QueueName = "<name of SQS Queue>"}
*  namespace             = "AWS/SQS"
*  period                = "60"
*  statistic             = "Sum"
*  threshold             = "100" 
*  alarm_description     = "The Queue has more than 100 messages"
*  email_address         = "<email>"
* }
* ```
*
* ## List of submodules
*
* ## Doc generation
*
* Documentation should be modified within `main.tf` and generated using [terraform-docs](https://github.com/segmentio/terraform-docs).
* Generate them like so:
*
* ```bash
* terraform-docs md ./ > README.md
* ```
*/

# SNS Topic for cloud-watch alarms
resource "aws_sns_topic" "cloud-watch-alarm-topic" {
  name = format("%s-topic", var.name)
}

# CloudWatch Alarm Definition
resource "aws_cloudwatch_metric_alarm" "cloud-watch-alarm" {
  alarm_name                = var.name
  comparison_operator       = var.comparison_operator #"GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.evaluation_periods #"2"
  metric_name               = var.metric_name #"CPUUtilization"
  namespace                 = var.namespace # "AWS/EC2"
  dimensions                = var.dimensions #{Name="Value"}
  period                    = var.period #"120"
  statistic                 = var.statistic #"Average"
  threshold                 = var.threshold #"80"
  alarm_description         = var.alarm_description #"This metric monitors ec2 cpu utilization"
  alarm_actions             = [aws_sns_topic.cloud-watch-alarm-topic.arn]
}

# Terraform does not support Email subscriptions to SNS Topics (Since it breaks the state-model). 
# So using a CloudFormation Template based workaround
# TODO : Check if this can use a AWS CLI-based workaround. 
# TODO : Add a sub-module so this can be called for mutiple subscriptions
data "template_file" "cloudformation_sns_email_subscription_stack" {
  template = file("${path.module}/templates/email-subscription-cft.tpl")

  vars = {
    email_address  = var.email_address
    topic_arn      = aws_sns_topic.cloud-watch-alarm-topic.arn
  }
}

resource "aws_cloudformation_stack" "sns-topic-subscription" {
  name          = format("%s-subscription-stack", var.name)
  template_body = data.template_file.cloudformation_sns_email_subscription_stack.rendered

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-subscription-stack", var.name)
    },
  )
}



output "Alarm_Arn" {
  value       = aws_cloudwatch_metric_alarm.cloud-watch-alarm.arn
  description = "ARN of the CloudWatch Alarm"
}







variable "name" {
  type        = string
  description = "Name of the Alert"
}

variable "comparison_operator" {
  type        = string
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold"
}
variable "evaluation_periods" {
  type        = string
  description = "The number of periods over which data is compared to the specified threshold."
}
variable "metric_name" {
  type        = string
  description = "The name for the alarm's associated metric"
}

variable "namespace" {
  type        = string
  description = "The namespace for the alarm's associated metric"
}

variable "dimensions" {
  type        = map
  description = "The dimensions for the alarm's associated metric"
}

variable "period" {
  type        = string
  description = "The period in seconds over which the specified statistic is applied."
}

variable "statistic" {
  type        = string
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
}
variable "threshold" {
  type        = string
  description = "The value against which the specified statistic is compared."
}

variable "alarm_description" {
  type        = string
  description = "The description for the alarm."
}

variable "email_address" {
  type        = string
  description = "Email address to Subscribe for the Alert/Notification"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags on the resources"
}




/**
* # configuration-recorder
*
* A Terraform module to create AWS Configuration Recorder. This creates the following resources
*  - Bucket For Config - CONFIG-<Account-name>
*  - SNS Topic For Config - <Account-Name>-AWS-CONFIG
*  - SNS Subscription    Email â€“ <emailId>
*  - ROLE for Config (with Access to above mentioned Resources)
*  - AWS COnfiguration Recorder
*  - AWS Config Delivery Channel
*
*
* ## Usage example
*
* ```hcl
* module "config-recorder" {
*   source                          = "<repo-url>/config/config-recorder"
*   accntName                       = "NewSandboxAccount"
*   kmsKeyArn                       = "arn:aws:kms:us-east-1:123456:key/xxxx-xxxx-xxxxx-xxxx"
* }
* ```
*
* ## List of submodules
*
* The following sub-modules/reources are used by this module
*
* NA
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

resource "aws_s3_bucket" "config_bucket" {
  bucket = "config-${var.accntName}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kmsKeyArn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id      = "config-data-archival"
    enabled = true

    #prefix = "log/"
    transition {
      days          = 180
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }
    expiration {
      days = 365
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.config_bucket.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_sns_topic" "config_sns" {
  name = "${var.accntName}-aws-config"
  tags = var.tags
}

#Create EMAIL subscription manually - as its NOT supported by terraform 

resource "aws_config_delivery_channel" "config_delivery_channel" {
  name           = "config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.id
  sns_topic_arn  = aws_sns_topic.config_sns.arn
  depends_on     = [aws_config_configuration_recorder.config_recorder]

  snapshot_delivery_properties {
    delivery_frequency = "Six_Hours"
  }
}

resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "config-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_iam_role" "config_role" {
  name = "awsconfig-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "config_role_policy" {
  name = "config-role-policy"
  role = aws_iam_role.config_role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [

      {
       "Effect": "Allow",
       "Action": ["s3:PutObject"],
       "Resource": ["${aws_s3_bucket.config_bucket.arn}/*"],
       "Condition":
        {
          "StringLike":
            {
              "s3:x-amz-acl": "bucket-owner-full-control"
            }
        }
     },
     {
       "Effect": "Allow",
       "Action": ["s3:GetBucketAcl"],
       "Resource": "${aws_s3_bucket.config_bucket.arn}"
     },
     {
        "Effect":"Allow",
        "Action":"sns:Publish",
        "Resource":"${aws_sns_topic.config_sns.arn}"
     }
  ]
}
POLICY

}

data "aws_iam_policy" "AWSConfigPolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_role_policy_attachment" "role-managed-policy-attachment" {
  role       = aws_iam_role.config_role.name
  policy_arn = data.aws_iam_policy.AWSConfigPolicy.arn
}

resource "aws_config_configuration_recorder_status" "config_recorder_enable" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_delivery_channel]
}






output "config_recorder_id" {
  value       = aws_config_configuration_recorder.config_recorder.id
  description = "ID of the AWS Config Recorder"
}




variable "accntName" {
  type        = string
  description = "Name of the new Account"
}

variable "kmsKeyArn" {
  type        = string
  description = "ARN of the KMS Key to be used for Encryption"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to add to the resources"
}
#Create IAM Role attached to the Instance
resource "aws_iam_role" "ec2-ssm-role" {
  name = "ec2-ssm-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "ec2-ssm-role"
  }
}

resource "aws_ssm_document" "ssm_join_domain_doc" {
name = "ssm_join_domain_doc"
document_type = "Command"
content = <<DOC
{
    "schemaVersion": "1.0",
    "description": "Automatic Domain Join Configuration",
    "runtimeConfig": {
        "aws:domainJoin": {
            "properties": {
                "directoryId": "${aws_directory_service_directory.touchad.id}",
                "directoryName": "${var.domain_name}",
                "dnsIpAddresses": ${jsonencode(aws_directory_service_directory.touchad.dns_ip_addresses)}
            }
        }
    }
}
DOC
}




# #The command document is used to join the machine to the domain.
# resource "aws_ssm_document" "ssm_join_domain_doc" {
# 	name  = "ssm_join_domain_doc"
# 	document_type = "Command"

# 	content = <<DOC
# {
#         "schemaVersion": "2.0",
#         "description": "Join an instance to a domain",
#         "mainSteps": [{
#            "aws:domainJoin": {
#                "properties": {
#                   "directoryId": "${aws_directory_service_directory.touchad.id}",
#                   "directoryName": "${var.domain_name}",
#                   "directoryOU": "${var.dir_computer_ou}",
#                   "dnsIpAddresses": ${jsonencode(aws_directory_service_directory.touchad.dns_ip_addresses)}
#                }
#            }
#         }
#         ]
# }
# DOC

# 	depends_on = [aws_directory_service_directory.touchad]
# }


# Associate document to window instance for SSM to automatically run the commands against the instance
resource "aws_ssm_association" "ssm_association_instance" {
	name = aws_ssm_document.ssm_join_domain_doc.name
	instance_id = aws_instance.windows_instance.id
	depends_on = [aws_ssm_document.ssm_join_domain_doc, aws_instance.windows_instance]
}


resource "aws_iam_instance_profile" "ec2-ssm-role-profile" {
  name = "ec2-ssm-role-profile"
  role = aws_iam_role.ec2-ssm-role.name
}


resource "aws_iam_role_policy_attachment" "ec2-ssm-role-policy" {
  role = aws_iam_role.ec2-ssm-role.id
  count = 2
  # policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  policy_arn = var.ssm_policy[count.index]
}

# output "ec2-ssm-role-profile-id" {
#   value = "${aws_iam_instance_profile.ec2-ssm-role-policy.id}"
# }
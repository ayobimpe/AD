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

# Instance role to link the role
resource "aws_iam_instance_profile" "ec2-ssm-role-profile" {
  name = "ec2-ssm-role-profile"
  role = aws_iam_role.ec2-ssm-role.name
}


# Attach the policy to the ssm role created to join the windows instance to the domain
resource "aws_iam_role_policy_attachment" "ec2-ssm-role-policy" {
  role = aws_iam_role.ec2-ssm-role.id
  count = 2
  policy_arn = var.ssm_policy_arn[count.index]
}




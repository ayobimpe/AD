#Create IAM Role that gives BRM EC2 instance access to S3 bucket
resource "aws_iam_role" "brmdb_role" {
  name = "brmdb_role"

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
      tag-key = "BRM_Instance_Role"
  }
}


# Create Instance profile to link to the IAM Role
resource "aws_iam_instance_profile" "brbinstance_profile" {
  name = "brm_profile"
  role = "${aws_iam_role.brmdb_role.name}"
}

# Create IAM Role Policy
resource "aws_iam_role_policy" "instance_policy" {
  name = "instance_policy"
  role = "${aws_iam_role.brmdb_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",

      "Resource": "arn:aws:s3:::brmdbbackupp"
    }
  ]
}
EOF
}
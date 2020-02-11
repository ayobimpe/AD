# provider "aws" {
#  region = "us-east-1"
# }


#Create EC2 Instance
resource "aws_instance" "windows_instance" {
  ami                    = "ami-02daaf23b3890d162"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-28c4dc06"
  key_name               = "Practice"
  iam_instance_profile   = aws_iam_instance_profile.ec2-ssm-role-profile.name
  vpc_security_group_ids = ["sg-0807bd9a8c25fea49"]
  tags = {
    Name = "windows_instance"
  }
}







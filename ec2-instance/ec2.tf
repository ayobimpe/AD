data "aws_ami" "windows" {
 most_recent = true

 filter {
   name   = "name"
   values = ["Windows Server 2016"]
 }




#Create EC2 Instance
resource "aws_instance" "windows_instance" {
  ami                         = data.aws_ami.windows.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  count                       = length(var.subnet_id)
  subnet_id                   = var.subnet_id[count.index]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2-ssm-role-profile.name
  vpc_security_group_ids      = [var.security_group_id]
  tags = {
    Name = var.project_name}-ad
    description = awsgss-ad
  }
}






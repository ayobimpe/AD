# Define the security group for the windows 
resource "aws_security_group" "awsgss_sg" {
  name = "webserversg"
  description = "Allow incoming SSH access"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["184.182.197.50"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = false
  }


  vpc_id= aws_vpc.aws_gss_vpc.id

  tags = {
    Name = "awsgss_sg"
  }
}

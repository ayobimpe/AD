# Allow incoming SSH Access and Oracle Port  for BRM Node Database
resource "aws_security_group" "BRM-DB-sg" {
  name = "BRM_Database_SG"
  description = "allow connection to BRM database"
  vpc_id = var.vpc_id

  tags = {
    Name = var.BRM-DB-sg-tag
  }
}


resource "aws_security_group_rule" "oracleport" {
  type            = "ingress"
  from_port       = var.brm_oracleport
  to_port         = var.brm_oracleport
  protocol        = var.brm_protocol
  security_group_id = aws_security_group.BRM-DB-sg.id
  source_security_group_id = var.appinstancesg
}


resource "aws_security_group_rule" "sshaccess" {
  type            = "ingress"
  from_port       = var.sshaccess_port
  to_port         = var.sshaccess_port
  protocol        = var.brm_protocol
  source_security_group_id = aws_security_group.BRM-DB-sg.id
  security_group_id = aws_security_group.BRM-DB-sg.id

}

resource "aws_security_group_rule" "allowtraffic" {
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["14.0.0.0/16"]
  # source_security_group_id = aws_security_group.BRM-DB-sg.id
  security_group_id = aws_security_group.BRM-DB-sg.id
}


resource "aws_security_group_rule" "outbound" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.BRM-DB-sg.id
}


output "BRM-DB-sg" {
  value = "${aws_security_group.BRM-DB-sg.id}"
}
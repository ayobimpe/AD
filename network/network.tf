provider "aws" {
 region = var.region
}


data "aws_availability_zones" "azs" {
  state = "available"
}

#Create Brm VPC 
resource "aws_vpc" "brm_vpc" {
  cidr_block         = var.vpc_cidr
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "brm_vpc"
  }
}

#Create Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.brm_vpc.id}"
  count   = length(var.publicsubnet_cidrblocks)
  cidr_block = "${element(var.publicsubnet_cidrblocks, count.index)}"
  availability_zone = "${data.aws_availability_zones.azs.names[count.index]}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-subnet${count.index + 1} "
  }
}

#Create Private Subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.brm_vpc.id}"
  count   = length(var.privatesubnet_cidrblocks)
  cidr_block = "${element(var.privatesubnet_cidrblocks, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "private-subnet${count.index + 1} "
  }
}


# Define internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.brm_vpc.id}"

  tags = {
    Name = "BRM IGW"
  }
}

# Create Elastic IP to assign to NAT Gateway
resource "aws_eip" "EIP" {
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]
  }

# Create nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.EIP.id}"
  subnet_id = aws_subnet.public-subnet[0].id
  depends_on = ["aws_internet_gateway.gw"]

  tags = {
    Name = "BRM NAT GW"
  }
}


# Create Public route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.brm_vpc.id}"

  route {
    cidr_block = var.cidr_block
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "Public Subnet RT"
  }
}

# Create private route table for the VPC
resource "aws_route_table" "private-rt" {
  vpc_id = "${aws_vpc.brm_vpc.id}"
  
  tags = {
    Name = "Private Subnet RT"
  }
}


resource "aws_route" "private_route" {
   route_table_id  = "${aws_route_table.private-rt.id}"
   destination_cidr_block = var.cidr_block
   nat_gateway_id = "${aws_nat_gateway.nat.id}"
} 

#Associate Public Subnet association
resource "aws_route_table_association" "public-subnet_association" {
  count   = "${length(aws_subnet.public-subnet.*.id)}"
  subnet_id  = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

#Associate Private Subnet association
resource "aws_route_table_association" "private-subnet_association" {
  count   = "${length(aws_subnet.private-subnet.*.id)}"
  subnet_id  = "${element(aws_subnet.private-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private-rt.id}"
}



output "vpc_id" {
  value = aws_vpc.brm_vpc.id
}


output "db_subnet" {
  value = "${slice(aws_subnet.private-subnet.*.id,0,2)}"
}

output "asg_subnet" {
  value = "${slice(aws_subnet.private-subnet.*.id,2,4)}"
}
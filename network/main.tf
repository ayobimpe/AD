data "aws_availability_zones" "az" {
  state = "available"
}


resource "aws_vpc" "aws_gss_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "aws_gss_vpc"
  }
}


resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.aws_gss_vpc.id
  count   = length(var.publicsubnet_cidrblocks)
  cidr_block = "${element(var.publicsubnet_cidrblocks, count.index)}"
  availability_zone = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-subnet${count.index + 1} "
  }
}


# Define internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.aws_gss_vpc.id}"

  tags = {
    Name = "igw"
  }
}

# Create Public route table
resource "aws_route_table" "gss-public-rt" {
  vpc_id = "${aws_vpc.gss.id}"

  route {
    cidr_block = "${var.cidr_block}"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "Public Subnet RT"
  }
}


# Create Route table association for the public subnet
resource "aws_route_table_association" "public-subnet_association" {
  count   = "${length(aws_subnet.public-subnet.*.id)}"
  subnet_id  = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}
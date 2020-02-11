provider "aws" {
 region = "var.region"
}

data "aws_ssm_parameter" "admin_password" {
  name = "admin_password"
}

# Create Directory Service
resource "aws_directory_service_directory" "aws_gss_ad" {
	name     = var.domain_name
	password = data.aws_ssm_parameter.admin_password
	size     = "Large"
	type     = var.dir_type
	vpc_settings {
		vpc_id     = var.vpc_id
		subnet_ids = ["subnet-28c4dc06", "subnet-4ffedf71"]
	}
  tags = {
    Name = "aws_gss_ad"
  }
}


# Create DHCP Option set
resource "aws_vpc_dhcp_options" "aws_gss_vpc_dhcp" {
  domain_name          = "awsgss.gov"
  domain_name_servers  = aws_directory_service_directory.aws_gss_ad.dns_ip_addresses
}


# Associate DHCP Option Set to VPC
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.aws_gss_vpc_dhcp.id
}



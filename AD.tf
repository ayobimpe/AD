provider "aws" {
 region = "us-east-1"
}


# Create Directory Service
resource "aws_directory_service_directory" "touchad" {
	name     = var.domain_name
	password = var.admin_password
	size     = "Large"
	type     = var.dir_type
	vpc_settings {
		vpc_id     = var.vpc_id
		# vpc_id = aws_vpc.vpc_myapp.id
		subnet_ids = ["subnet-28c4dc06", "subnet-4ffedf71"]
			# "${aws_subnet.subnet_priv_az1.id}",
			# "${aws_subnet.subnet_priv_az2.id}"
	}
  tags = {
    Project = "touch_ad"
  }
}


# Create DHCP Option set
resource "aws_vpc_dhcp_options" "touch_ad_dhcp" {
  domain_name          = "touch.com"
  domain_name_servers  = aws_directory_service_directory.touchad.dns_ip_addresses
  # domain_name_servers  = [aws_directory_service_directory.touch_ad.dns_ip_addresses]
  # ntp_servers          = ["${aws_directory_service_directory.touch_ad.dns_ip_addresses}"]
  # netbios_name_servers = ["${aws_directory_service_directory.touch_ad.dns_ip_addresses}"]
  # netbios_node_type    = 2
}




# Create DHCP Association with the directory service
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.touch_ad_dhcp.id
}


output "touch_ad_dhcp_id" {
  value = aws_vpc_dhcp_options.touch_ad_dhcp.id
}


output "touch_ad_dns_ip_addresses" {
  value = aws_directory_service_directory.touchad.dns_ip_addresses
}

output "touch_ad_dns_name" {
  value = aws_directory_service_directory.touchad.name
}
output "aws_gss_vpc_dhcp_id" {
  value = aws_vpc_dhcp_options.aws_gss_vpc_dhcp.id
}


output "aws_gss_vpc_dns_ip_addresses" {
  value = aws_directory_service_directory.aws_gss_ad.dns_ip_addresses
}

output "aws_gss_vpc_dns_name" {
  value = aws_directory_service_directory.aws_gss_ad.name
}
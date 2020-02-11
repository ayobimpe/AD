resource "aws_ssm_parameter" "ssm_password" {
  name        = "/domain/password"
  description = "Domain password"
  type        = "SecureString"
  value       = var.domain_password
  key_id      = var.kms_key_id
  overwrite   = true
}



#The command document is used to join the domain.
resource "aws_ssm_document" "ssm_join_domain_doc" {
	name  = "ssm_join_domain_doc"
	document_type = "Command"

	content = <<DOC
{
        "schemaVersion": "1.0",
        "description": "Automatically domain join configuration",
        "runtimeConfig": {
           "aws:domainJoin": {
               "properties": {
                  "directoryId": "${aws_directory_service_directory.aws_gss_ad.id}",
                  "directoryName": "${var.domain_name}",
                  "directoryOU": "${var.dir_computer_ou}",
                  "dnsIpAddresses": ${jsonencode(aws_directory_service_directory.aws_gss_ad.dns_ip_addresses)}
               }
           }
        }
}
DOC

	depends_on = [aws_directory_service_directory.aws_gss_ad]
}


# Associate document to window instance for SSM to automatically run the commands against the instance
resource "aws_ssm_association" "ssm_association_instance" {
	name = aws_ssm_document.ssm_join_domain_doc.name
	instance_id = aws_instance.windows_instance.id
	depends_on = [aws_ssm_document.ssm_join_domain_doc, aws_instance.windows_instance]
}



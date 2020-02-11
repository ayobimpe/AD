resource "aws_s3_bucket" "statebackend" {
  acl           = var.acl
  bucket        = var.bucket_name
  region        = var.region
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id        = var.kms_key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = {
  Name        = "state_bucket"
}

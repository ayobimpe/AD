#Create KMS Key
resource "aws_kms_key" "brms3kmskey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = var.kms_deletion_in_days   # Duration in days after which the key is deleted after destruction of KMS Key
  tags = {
    Name = var.brm_key_tag
  }
}


#Create S3 Bucket for BRM database backup
resource "aws_s3_bucket" "brmbackup" {
  bucket = "brmdbbackupp"
  acl    = "private"
  region = var.region
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.brms3kmskey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name        = "db_backup"
    Environment = "db"
  }
}

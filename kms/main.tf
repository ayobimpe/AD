resource "aws_kms_key" "awsgsskey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = var.kms_deletion_in_days
}

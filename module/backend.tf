module "kms_key" {
  source     = "../modules/kms"
  alias_name = "alias/hud/${var.project_name}"
}

module "terraform_state_bucket" {
  source      = "../modules/s3"
  bucket_name = "tf.${var.project_name}.hud"
  key_id      = module.kms_key.key.id
  region      = var.region
}


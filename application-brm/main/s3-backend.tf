terraform {
  backend "s3" {
    bucket = "brmcodes3"
    key    = "brm/appdbstatefile"
    region = "us-east-1"
  }
}
terraform {
  backend "s3" {
    bucket = "brmcodes3"
    key    = "brm/frontendstatefile"
    region = "us-east-1"
  }
}
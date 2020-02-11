terraform {
  backend "s3" {
    bucket = "brmcodes3v2"
    key    = "brm/networkstatefile"
    region = "us-east-1"
  }
}

terraform {
  backend "s3" {
    bucket = "devops-tools-remote-state"
    key    = "eshop/terraform.tfstate"
    region = "eu-west-1"
  }
}
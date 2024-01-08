terraform {
  backend "s3" {
    bucket = "devops-eshop-state"
    key    = "devops/eshop/terraform.tfstate"
    region = "eu-central-1"
  }
}
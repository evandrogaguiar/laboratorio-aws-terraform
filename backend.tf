terraform {
  backend "s3" {
    bucket = "tfstate-637423577083"
    key    = "laboratorio-aws-terraform/terraform.tfstate"
    region = "us-east-1"
  }
}
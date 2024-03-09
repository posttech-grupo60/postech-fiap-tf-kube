terraform {
  backend "s3" {
    bucket = "fiap-challenge-bucket-terraform-state"
    key    = "PROD/terraform.tfstate"
    region = "us-east-1"
  }
}

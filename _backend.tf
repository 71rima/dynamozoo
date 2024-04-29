#Configure backend configuration
terraform {
  required_version = ">= 0.1"
  backend "s3" {
    bucket         = "tfstate-dynamozoo1232523"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state-dynamozoo"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.41"
    }
  }
}
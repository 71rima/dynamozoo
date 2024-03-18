terraform {
  required_version = ">= 1.7"
  backend "s3" {
    bucket         = "tfstate-dynamozoo1232523"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state-dynamozoo"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.41"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = local.region
  shared_config_files      = ["/Users/amirel-shennawy/.aws/config"]
  shared_credentials_files = ["/Users/amirel-shennawy/.aws/credentials"]
  default_tags {
    tags = {
      owner       = "TecRacer"
      project     = "dynamozoo"
      Environment = "Dev"
      Terraform   = true
    }
  }
}

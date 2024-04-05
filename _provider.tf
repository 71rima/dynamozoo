# Configure the AWS Provider
provider "aws" {
  region = local.aws_region
  default_tags {
    tags = {
      owner       = local.project_owner
      project     = local.project_name
      Environment = var.environment
      Terraform   = true
    }
  }
}

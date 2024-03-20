locals {
  region           = "us-east-1"
  azs              = ["us-east-1a", "us-east-1b"]
  vpc_cidr         = "10.0.0.0/16"
  project_name     = "dynamozoo"
  private_subnets  = ["10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.0.0/24", "10.0.1.0/24"]
  database_subnets = ["10.0.4.0/24", "10.0.5.0/24"]

  s3_origin_id = aws_s3_bucket.static_website.id

}

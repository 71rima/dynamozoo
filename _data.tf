#find hosted zone id
data "aws_route53_zone" "this" {
  name         = "elshennawy.de"
  private_zone = false
}

#find CloudFront AWS managed Cache policy "CachingDisabled"
data "aws_cloudfront_cache_policy" "cacheDisabled" {
  name = "Managed-CachingDisabled"
}

#Lambda Payload
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_src/lambda.py"
  output_path = "${path.module}/lambda_src/lambda_function_payload.zip"
}

#current caller identity
data "aws_caller_identity" "current" {}

#current caller region
data "aws_region" "current" {}

#get default tags from provider
data "aws_default_tags" "current" {}

## Backend

#statestorage
data "aws_s3_bucket" "tfstate" {
  bucket = var.s3_state_bucket_name
}
#cf logs - bucket
data "aws_s3_bucket" "logs" {
  bucket = var.s3_logs_bucket_name
}
#state lock dynamodb
data "aws_dynamodb_table" "statelock" {
  name = var.dynamodb_state_lock_name
}


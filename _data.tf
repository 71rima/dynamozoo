#find hosted zone id
data "aws_route53_zone" "this" {
  name         = "elshennawy.de"
  private_zone = false
}

#find acm certificate
data "aws_acm_certificate" "this" {
  domain   = "www.web.elshennawy.de"
  statuses = ["ISSUED"]
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

## Backend

#statestorage
data "aws_s3_bucket" "this" {
  bucket = var.s3_statebucket
}
#cf logs - bucket
data "aws_s3_bucket" "logs" {
  bucket = var.s3_logsbucket
}
#state dynamodb
data "aws_dynamodb_table" "statelock" {
  name = var.dynamodb_statelock
}

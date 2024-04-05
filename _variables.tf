#Development Configuration
variable "environment" {
  type        = string
  description = "The environment used for the project."
  default     = "dev"
}

#------------------------------------------------------------
#domain cloudfront
variable "domain" {
  type        = string
  description = "The domain name of the website."
}
variable "domain_www" {
  type        = string
  description = "The domain name of the website including www."
}
#------------------------------------------------------------
#api gateway
variable "api_domain" {
  type        = string
  description = "The name of the API Gateway."
}
#------------------------------------------------------------
#Backend
variable "s3_state_bucket_name" {
  type        = string
  description = "The name of the s3 statebucket."
}
variable "s3_logs_bucket_name" {
  type        = string
  description = "The name of the s3 cflogsbucket."
}
variable "dynamodb_state_lock_name" {
  type        = string
  description = "The name of the dynamodb table used for Terraform state lock."
}

#------------------------------------------------------------
#S3 Content Bucket
variable "s3_content_bucket_name" {
  type        = string
  description = "The name of the s3 content bucket."
}
#path to content source
variable "content_source_path" {
  type        = string
  description = "The path to the content source directory."
}
#------------------------------------------------------------
#S3 Website Bucket
variable "s3_website_bucket_name" {
  type        = string
  description = "The name of the s3 website bucket."
}
#------------------------------------------------------------
#Dynamo Db Table
variable "dynamodb_table_name" {
  type        = string
  description = "The name of the dynamodb table used for Metadata."
}
#------------------------------------------------------------
#templates path
variable "templates_path" {
  type        = string
  description = "The path to the templates directory."
}
#website path
variable "website_path" {
  type        = string
  description = "The path to the website directory."
}
#------------------------------------------------------------
#Lambda
variable "lambda_function_name" {
  type        = string
  description = "The name of the lambda function."
}
variable "lambda_runtime" {
  type        = string
  description = "The runtime of the lambda function."
}

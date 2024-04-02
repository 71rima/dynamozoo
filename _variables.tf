#AWS specific configuration
variable "region" {
  type        = string
  description = "The AWS region used for the project."
}
variable "account_id" {
  type        = string
  description = "The AWS account number used for the project."
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
#Backend
variable "s3_statebucket" {
  type        = string
  description = "The name of the s3 statebucket."
}
variable "s3_logsbucket" {
  type        = string
  description = "The name of the s3 cflogsbucket."
}
variable "dynamodb_statelock" {
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
#Lambda
variable "lambda_zip_file_name" {
  type        = string
  description = "The name of the lambda zip file."
}
variable "lambda_handler" {
  type        = string
  description = "The name of the lambda handler."
}
variable "lambda_function_name" {
  type        = string
  description = "The name of the lambda function."
}
variable "lambda_runtime" {
  type        = string
  description = "The runtime of the lambda function."
}

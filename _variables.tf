variable "aliases" {
  description = "Alias Records for domain and subdomain"
  type        = map(string)
  default = {
    "alias1" = "elshennawy.de"
    "alias2" = "web.elshennawy.de"
  }
}
variable "certificate_arn" {
  type        = string
  description = "The ARN of the certificate used for HTTPS."
}
variable "s3_statebucket" {
  type        = string
  description = "The name of the s3 statebucket."
}
variable "region" {
  type        = string
  description = "The AWS region used for the project."
}
variable "s3_logsbucket" {
  type = string
  description = "The name of the s3 cflogsbucket."
}
variable "dynamodb_statelock" {
  type = string
  description = "The name of the dynamodb table used for Terraform state lock."
}
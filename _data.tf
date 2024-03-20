#find hosted zone id
data "aws_route53_zone" "this" {
  name         = "elshennawy.de"
  private_zone = false
}

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
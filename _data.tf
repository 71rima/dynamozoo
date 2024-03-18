#find hosted zone id
data "aws_route53_zone" "this" {
  name         = "elshennawy.de"
  private_zone = false
}
#statestorage
data "aws_s3_bucket" "this" {
  bucket = s3_statebucket
}


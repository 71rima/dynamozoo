locals {
  project_name   = "dynamozoo"
  s3_origin_id   = aws_s3_bucket.static_website.id
  source_account = data.aws_caller_identity.current.account_id
}

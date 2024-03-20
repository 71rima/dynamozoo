resource "aws_s3_bucket" "cf_logs" {
  bucket = "dynamozoo-log-bucket124151234"

  tags = {
    Name = "cf-logs"
  }
}

resource "aws_s3_bucket_ownership_controls" "cf_logs" {
  bucket = aws_s3_bucket.cf_logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
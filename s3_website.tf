resource "aws_s3_bucket" "static_website" {
  bucket = var.s3_website_bucket_name
}
resource "aws_s3_bucket_ownership_controls" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "static_website_acl" {
  bucket = aws_s3_bucket.static_website.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "index.html"
  source       = "${path.module}/website_src/DynamoZoo/index.html" #TODO: Variable oder so lassen?
  content_type = "text/html"

  etag = filemd5("${path.module}/website_src/DynamoZoo/index.html")
}
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "error.html"
  source       = "${path.module}/website_src/DynamoZoo/error.html"
  content_type = "text/html"

  etag = filemd5("${path.module}/website_src/DynamoZoo/error.html")
}

#policy for OAC read access
resource "aws_s3_bucket_policy" "static_website_allow_oac" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.static_website.json
}
#TODO: Template file https://developer.hashicorp.com/terraform/language/functions/templatefile
data "aws_iam_policy_document" "static_website" {
  statement {
    sid       = "AllowOACReadAccess"
    effect    = "Allow"
    resources = ["${aws_s3_bucket.static_website.arn}/*"]

    actions = [
      "s3:GetObject"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_cloudfront_distribution.my_distribution.arn
      ]
    }
  }
}

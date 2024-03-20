resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "oac"
  description                       = "The OAC of the CloudFront Website Origin."
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "my_distribution" {
  #TODO: CF Function + Aliases + function association
  origin {
    domain_name              = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }
  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.static_website.bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" #TODO local CachingDisabled Managed Policy from AWS

  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  logging_config {
    bucket = "${data.aws_s3_bucket.logs.id}.s3.amazonaws.com"
    prefix = "cflogs-"
  }
}

#Origin Access Controll - prefered above OAI (Short Term Credentials, more versatile)

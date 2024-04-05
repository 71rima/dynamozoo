resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "oac"
  description                       = "The OAC of the CloudFront Website Origin."
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "my_distribution" {

  origin {
    domain_name              = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }
  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.static_website.bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"] #TODO: test only get; test without
    cached_methods         = ["GET", "HEAD"]
    #CachingDisabled Managed Policy from AWS
    cache_policy_id = data.aws_cloudfront_cache_policy.cacheDisabled.id
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.this.arn
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only" #must be set; other options "vip" include extra charges because cf need to use a dedicated ip adress
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  logging_config {
    bucket = "${data.aws_s3_bucket.logs.id}.s3.amazonaws.com"
    prefix = "cflogs-${local.name_suffix}"
  }
  aliases = [var.domain, var.domain_www]
}


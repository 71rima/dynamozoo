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
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    cache_policy_id        = data.aws_cloudfront_cache_policy.cacheDisabled.id #CachingDisabled Managed Policy from AWS

  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = data.aws_acm_certificate.this.arn
    ssl_support_method             = "sni-only" #must be set; other options "vip" include extra charges because cf need to use a dedicated ip adress
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  logging_config {
    bucket = "${data.aws_s3_bucket.logs.id}.s3.amazonaws.com"
    prefix = "cflogs-"
  }
  aliases = [var.domain, var.domain_www]
}

# Route53 Record - Routes traffic to Cloudfront CNAME Record

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.domain_www
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.my_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.my_distribution.hosted_zone_id
    evaluate_target_health = false
  }

}
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.my_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.my_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

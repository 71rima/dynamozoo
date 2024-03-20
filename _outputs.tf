output "cloudfront_website_domain" {
  description = "Domain of the CloudFront distribution."
  value       = aws_cloudfront_distribution.my_distribution.domain_name
}


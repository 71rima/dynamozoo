# CF - Domain
output "cloudfront_website_url" {
description = "URL of the CloudFront distribution."
value       = aws_cloudfront_distribution.my_distribution.domain_name 
}
# CloudFront Aliases local.domain
output "cloudfront_aliases" {
  description = "Aliases of the CloudFront distribution."
value       = var.domain 
}
# CloudFront Aliases local.domain
output "cloudfront_aliases_www" {
  description = "WWW Alias of the CloudFront distribution."
  value = var.domain_www 
}
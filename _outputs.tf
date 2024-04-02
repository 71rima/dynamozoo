# CF - Domain
output "cloudfront_website_url" {
description = "URL of the CloudFront distribution."
value       = aws_cloudfront_distribution.my_distribution.domain_name 
}
# CloudFront Aliases
output "cloudfront_aliases_www" {
  description = "WWW Alias of the CloudFront distribution."
  value = aws_cloudfront_distribution.my_distribution.aliases 
}
# Custom Domain for API Gateway
output "custom_domain_name_apiGateway" {
  description = "Custom domain name for API Gateway."
  value = aws_api_gateway_domain_name.this.domain_name
}
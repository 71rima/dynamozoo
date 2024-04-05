#aws cloudwatch group for api gateway log group
resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/api_gateway/${aws_api_gateway_rest_api.FileService.name}"
  retention_in_days = 0
}
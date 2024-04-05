resource "aws_lambda_function" "test_lambda" {
  filename         = local.lambda_zip_file_name
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = local.lambda_handler
  runtime          = var.lambda_runtime #Variable sinnvoll?! - Eigentl verändert es sich doch nicht
  source_code_hash = data.archive_file.lambda.output_base64sha256
}

#Lambda Permission for ApiGateway: InvokeFunction - Eigentl zu lambda.tf oder?
# More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
resource "aws_lambda_permission" "allow_apiGateway_invokeFunction" {
  statement_id   = "AllowExecutionFromApiGateway"
  action         = "lambda:InvokeFunction"
  function_name  = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}" #var.accountid oder data.aws_caller_identity.current.id
  principal      = "apigateway.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
  source_arn     = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.FileService.id}/*/${aws_api_gateway_method.getAnimal.http_method}${aws_api_gateway_resource.animalResource.path}"
}
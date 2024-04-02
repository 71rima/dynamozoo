#Lambda Policy
resource "aws_iam_policy" "lambda_cwLogs" {
  name   = "lamba_cwLogs"
  policy = file("${path.module}/templates/lambda_executionRole_cwLogs.json")
}
resource "aws_iam_policy" "lambda_dynamodb" {
  name   = "lambda_dynamodb"
  policy = file("${path.module}/templates/lambda_dynamodb.json")
}
resource "aws_iam_policy" "lambda_s3_presignedUrl" {
  name   = "lambda_s3_presignedUrl"
  policy = file("${path.module}/templates/lambda_s3_presignedUrl.json")
}
#TODO One Policy Attachment with for each and data source? OR One Policy with all Statements in json file?
#Lambda Policy attachment
resource "aws_iam_role_policy_attachment" "lambda_cwLogs" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_cwLogs.arn
}
resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb.arn
}
resource "aws_iam_role_policy_attachment" "lambda_s3_presignedUrl" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_s3_presignedUrl.arn
}
#Lambda IAM Role
resource "aws_iam_role" "lambda_iam_role" {
  name               = "lambda_iam_role"
  assume_role_policy = file("${path.module}/templates/lambda_assumeRole.json")
  #TODO: So oder wie in s3 content: var.template_path (da häufig benutzt), Nachteil: kein path.module sondern .
}
#Lambda Permission for ApiGateway: InvokeFunction
# More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
resource "aws_lambda_permission" "allow_apiGateway_invokeFunction" {
  statement_id   = "AllowExecutionFromApiGateway"
  action         = "lambda:InvokeFunction"
  function_name  = "arn:aws:lambda:${var.region}:${var.account_id}:function:${var.lambda_function_name}" #var.accountid oder data.aws_caller_identity.current.id
  principal      = "apigateway.amazonaws.com"
  source_account = var.account_id
  source_arn     = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.FileService.id}/*/${aws_api_gateway_method.getAnimal.http_method}${aws_api_gateway_resource.animalResource.path}"

}
#------------------------------------------------------------------------------------------------------------------------------------------------



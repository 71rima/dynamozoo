resource "aws_api_gateway_rest_api" "FileService" {
  name        = "FileService"
  description = "This is the FileService API for Dynamozoo."
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "animalResource" {
  rest_api_id = aws_api_gateway_rest_api.FileService.id
  parent_id   = aws_api_gateway_rest_api.FileService.root_resource_id
  path_part   = "{animal}"
}

resource "aws_api_gateway_method" "getAnimal" {
  rest_api_id   = aws_api_gateway_rest_api.FileService.id
  resource_id   = aws_api_gateway_resource.animalResource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.FileService.id
  resource_id             = aws_api_gateway_resource.animalResource.id
  http_method             = aws_api_gateway_method.getAnimal.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.test_lambda.invoke_arn
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.FileService.id
  stage_name    = "Development"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.FileService.id

  # configuration below will redeploy if any of the  terraform configuration 
  #files in the api_gateway.tf file change.
  #triggers = {
  #  redeployment = filesha1("${path.module}/api_gateway.tf")
  #}
  #configuration below will redeploy only if 
  # important parts (api: resources, methods orintegration)
  # differ

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.FileService.body,
      aws_api_gateway_resource.animalResource.id,
      aws_api_gateway_method.getAnimal.id,
      aws_api_gateway_integration.integration.id,
    ]))
  } 
  
  depends_on = [aws_api_gateway_integration.integration]    
  lifecycle {
    create_before_destroy = true
  }
}

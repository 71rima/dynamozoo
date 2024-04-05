resource "aws_api_gateway_rest_api" "FileService" {
  name        = "FileService"
  description = "This is the FileService API for Dynamozoo."
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  lifecycle {
    create_before_destroy = true
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

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.FileService.id
  stage_name    = var.environment

  #cache_cluster_enabled = true #CKV_AWS_120 invalid stage cache size: null
  xray_tracing_enabled = true # CKV_AWS_73
  /*access_log_settings {        #CKV_AWS_76 
    destination_arn = aws_cloudwatch_log_group.api_gateway_log_group.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }*/
}


#--------------------------------------------------------------------------------------
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
      aws_api_gateway_integration.integration.id

    ]))
  }

  depends_on = [aws_api_gateway_integration.integration]
  lifecycle {
    create_before_destroy = true
  }
}

#Regional (ACM Certificate) for domain "api.web.elshennawy.de"
resource "aws_api_gateway_domain_name" "this" {
  domain_name              = var.api_domain
  regional_certificate_arn = aws_acm_certificate_validation.this.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
  security_policy = "TLS_1_2"
  #depends_on = [aws_acm_certificate_validation.this.certificate_arn]
}

# Base path mapping for domain "api.web.elshennawy.de"
resource "aws_api_gateway_base_path_mapping" "this" {
  api_id      = aws_api_gateway_rest_api.FileService.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.this.domain_name
}


#--------------------------------------------------------------------------------------

locals {
  project_name         = "dynamozoo"
  project_owner        = "tecRacer"
  name_suffix          = "${local.project_name}-${var.environment}"
  lambda_handler       = "lambda.lambda_handler"
  lambda_zip_file_name = "./lambda_src/lambda_function_payload.zip"
  aws_region = "us-east-1"
}

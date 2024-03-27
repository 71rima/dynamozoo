resource "aws_lambda_function" "test_lambda" {
  filename         = var.lambda_zip_file_name
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime #Variable sinnvoll?! - Eigentl verändert es sich doch nicht
  source_code_hash = data.archive_file.lambda.output_base64sha256

}


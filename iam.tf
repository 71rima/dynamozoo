#Lambda Policy
resource "aws_iam_policy" "lambda_cwLogs" {
  name   = "lamba_cwLogs"
  policy = file("${path.module}/templates/lambda_executionRole_cwLogs.json")
}
resource "aws_iam_policy" "lambda_dynamodb" {
  name = "lambda_dynamodb"
  policy = templatefile("${var.templates_path}/lambda_dynamodb.json.tpl",
  { region = data.aws_region.current.name, account_id = data.aws_caller_identity.current.account_id, dynamodb_table = aws_dynamodb_table.this.name })
}
resource "aws_iam_policy" "lambda_s3_presignedUrl" {
  name = "lambda_s3_presignedUrl"
  policy = templatefile("${var.templates_path}/lambda_s3_presigned_url.json.tpl",
  { s3_content_bucket = aws_s3_bucket.content.id })
}
resource "aws_iam_policy" "lambda_kmsDecrypt" {
  name = "lambda_kmsDecrypt"
  policy = templatefile("${var.templates_path}/lambda_kmsDecrypt.json.tpl",
  { cmk_key_arn = aws_kms_key.cmk_dynamodb.arn })
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
resource "aws_iam_role_policy_attachment" "lambda_kmsDecrypt" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_kmsDecrypt.arn
}
#Lambda IAM Role
resource "aws_iam_role" "lambda_iam_role" {
  name               = "lambda_iam_role"
  assume_role_policy = file("${var.templates_path}/lambda_assumeRole.json")
  #TODO: So oder path.module/templates/ (var.templates - da häufig benutzt)
}

#------------------------------------------------------------------------------------------------------------------------------------------------



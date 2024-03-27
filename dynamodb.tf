#TODO: BP checken - KMS, Tags
resource "aws_dynamodb_table" "this" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Animal"

  attribute {
    name = "Animal"
    type = "S"
  }
 

}

resource "aws_dynamodb_table_item" "scurr" {
  table_name = aws_dynamodb_table.this.name
  hash_key   = aws_dynamodb_table.this.hash_key
  
  item       = <<ITEM
{
  "Animal": {"S": "Scurr"},
  "Url": {"S": "https://${aws_s3_bucket.content.bucket}.s3.amazonaws.com/${aws_s3_object.image_scurr.key}"}
}
ITEM
}

resource "aws_dynamodb_table_item" "cat" {
  table_name = aws_dynamodb_table.this.name
  hash_key   = aws_dynamodb_table.this.hash_key
  
  item       = <<ITEM
{
  "Animal": {"S": "Cat"},
  "Url": {"S": "https://${aws_s3_bucket.content.bucket}.s3.amazonaws.com/${aws_s3_object.image_cat.key}"}
}
ITEM
}
resource "aws_dynamodb_table_item" "dog" {
  table_name = aws_dynamodb_table.this.name
  hash_key   = aws_dynamodb_table.this.hash_key
  
  item       = <<ITEM
{
  "Animal": {"S": "Dog"},
  "Url": {"S": "https://${aws_s3_bucket.content.bucket}.s3.amazonaws.com/${aws_s3_object.image_dog.key}"}
}
ITEM
}

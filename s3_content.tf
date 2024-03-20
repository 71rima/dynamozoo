resource "aws_s3_bucket" "content" {
  bucket = "dynamozoo-content14412"

  tags = {
    Name = "s3_content"
  }
}

resource "aws_s3_object" "image_scurr" {
  bucket = aws_s3_bucket.content.id
  key    = "image_scurr.jpg"

  source = "${path.module}/s3_content_images/scurr.jpg"

  etag = filemd5("${path.module}/s3_content_images/scurr.jpg")
}
resource "aws_s3_object" "image_dog" {
  bucket = aws_s3_bucket.content.id
  key    = "image_dog.jpg"

  source = "${path.module}/s3_content_images/dog.jpg"

  etag = filemd5("${path.module}/s3_content_images/dog.jpg")
}
resource "aws_s3_object" "image_cat" {
  bucket = aws_s3_bucket.content.id
  key    = "image_cat.jpg"

  source = "${path.module}/s3_content_images/cat.jpg"

  etag = filemd5("${path.module}/s3_content_images/cat.jpg")
}

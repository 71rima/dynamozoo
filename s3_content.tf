resource "aws_s3_bucket" "content" {
  bucket = var.s3_content_bucket_name
}

/*resource "aws_s3_bucket_public_access_block" "this" {
   bucket = aws_s3_bucket.content.id

   block_public_acls   = true
   block_public_policy = true
}*/

resource "aws_s3_object" "image_scurr" {
  bucket       = aws_s3_bucket.content.id
  key          = "image_scurr.jpg"
  content_type = "image/jpeg"
  source       = "${var.content_source_path}/scurr.jpg"

  etag = filemd5("${var.content_source_path}/scurr.jpg")
}
resource "aws_s3_object" "image_dog" {
  bucket       = aws_s3_bucket.content.id
  key          = "image_dog.jpg"
  content_type = "image/jpeg"
  source       = "${var.content_source_path}/dog.jpg"

  etag = filemd5("${var.content_source_path}/dog.jpg")

}
resource "aws_s3_object" "image_cat" {
  bucket       = aws_s3_bucket.content.id
  key          = "image_cat.jpg"
  content_type = "image/jpeg"
  source       = "${var.content_source_path}/cat.jpg"

  etag = filemd5("${var.content_source_path}/cat.jpg")
}

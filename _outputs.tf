output "s3_state_arn" {
  description = "The ARN of the S3 bucket for state storage."
  value       = data.aws_s3_bucket.this.arn
}


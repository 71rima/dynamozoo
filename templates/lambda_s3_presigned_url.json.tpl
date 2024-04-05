{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaPresignedUrlS3",
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${s3_content_bucket}/*"
        }
    ]
}
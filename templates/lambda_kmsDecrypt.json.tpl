{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "enableKmsDecrypt",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "${cmk_key_arn}"
        }
    ]
}
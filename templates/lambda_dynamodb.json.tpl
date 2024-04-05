{
"Version": "2012-10-17",
"Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "dynamodb:GetItem"
        ],
        "Resource": "arn:aws:dynamodb:${region}:${account_id}:table/${dynamodb_table}"
    }
]
}
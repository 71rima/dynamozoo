import boto3
import json
import logging
from botocore.exceptions import ClientError


dynamodb = boto3.resource("dynamodb")   
table = dynamodb.Table('MetadataService')

s3 = boto3.client('s3')

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
   
    #get animal from url
    path = event['path'].split('/')[1]
   
    pathParam = event['pathParameters']['animal']
    
    #check parameters debugging
    print(path, pathParam)
    
    
    
    #GetItem from DynamoDB Get("Animal").Url
    response = table.get_item(
        Key={
            'Animal': pathParam,   #TODO error handling string
        }
    )
    print(response)
    url = response['Item']['Url']

    print(url)

    #get bucket name and object name from url
    bucket_name, object_name = get_bucket_name_and_object_from_url(url)
    print(bucket_name, object_name)

    #generate presigned url
    presigned_url = create_presigned_url(bucket_name, object_name)
    print(presigned_url)
    
    #Return the presigned Url to API Gateway
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({
            'presigned_url': presigned_url
        }),
        "isBase64Encoded": False
    }
    
def create_presigned_url(bucket_name, object_name, expiration=600):
    # Generate a presigned URL for the S3 object
    s3_client = boto3.client('s3')
    try:
        response = s3_client.generate_presigned_url('get_object',
                                                    Params={'Bucket': bucket_name,
                                                            'Key': object_name},
                                                    ExpiresIn=expiration)
    except ClientError as e:
        logging.error(e)
        return None
    
    # The response contains the presigned URL
    return response

def get_bucket_name_and_object_from_url(url):
    # Get the bucket name and object name from the URL
    bucket_url = url.split('/')[2]
    bucket_name = bucket_url.split('.')[0]
    object_name = '/'.join(url.split('/')[3:])
    return bucket_name, object_name

def respond(err, res=None):
    return {
        'statusCode': '400' if err else '200',
        'body': err.message if err else json.dumps(res),
        'headers': {
            'Content-Type': 'application/json',
        },
    }


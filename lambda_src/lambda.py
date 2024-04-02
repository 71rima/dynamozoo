import boto3
import json
import logging
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS clients and resources
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table('MetadataService')
s3_client = boto3.client('s3')

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))
    
    # Extract animal parameter from URL
    try:
        path_param = event['pathParameters']['animal']
    except KeyError:
        logger.error("Missing 'animal' parameter in the request path")
        return respond(Exception('Missing parameter'), None)

    # Get item from DynamoDB
    try:
        response = table.get_item(Key={'Animal': path_param})
        item = response.get('Item')
        if not item:
            logger.error("Item not found for animal: %s", path_param)
            return respond(Exception('Item not found'), None)
        
        url = item.get('Url')
        logger.info("Retrieved URL from DynamoDB: %s", url)
    except ClientError as e:
        logger.error("Error retrieving item from DynamoDB: %s", str(e))
        return respond(e, None)

    # Get bucket name and object name from URL
    bucket_name, object_name = get_bucket_name_and_object_from_url(url)
    logger.info("Bucket name: %s, Object name: %s", bucket_name, object_name)

    # Generate presigned URL
    try:
        presigned_url = create_presigned_url(bucket_name, object_name)
        logger.info("Generated presigned URL: %s", presigned_url)
    except ClientError as e:
        logger.error("Error generating presigned URL: %s", str(e))
        return respond(e, None)

    # Return presigned URL to API Gateway
    return respond(None, {'presigned_url': presigned_url})

def create_presigned_url(bucket_name, object_name, expiration=600):
    # Generate a presigned URL for the S3 object
    try:
        response = s3_client.generate_presigned_url('get_object',
                                                    Params={'Bucket': bucket_name,
                                                            'Key': object_name},
                                                    ExpiresIn=expiration)
        return response
    except ClientError as e:
        raise e

def get_bucket_name_and_object_from_url(url):
    # Get the bucket name and object name from the URL
    parts = url.split('/')
    bucket_url = parts[2]
    bucket_name = bucket_url.split('.')[0]
    object_name = '/'.join(parts[3:])
    return bucket_name, object_name

def respond(err, res):
    status_code = 400 if err else 200
    body = err.message if err else json.dumps(res)
    return {
        'statusCode': status_code,
        'body': body,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }

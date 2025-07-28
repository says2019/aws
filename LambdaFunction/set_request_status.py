import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('RequestStatusTable')


def handler(event, context):
    request_id = event['request_id']
    status = event['status']

    table.update_item(
        Key={'request_id': request_id},
        UpdateExpression="set #s = :s",
        ExpressionAttributeNames={'#s': 'status'},
        ExpressionAttributeValues={':s': status}
    )

    return {
        'statusCode': 200,
        'body': f'Status updated to {status} for request {request_id}.'
    }

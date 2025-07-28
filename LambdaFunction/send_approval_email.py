import json
import boto3

ses = boto3.client('ses')


def handler(event, context):
    email = event['email']
    request_id = event['request_id']

    response = ses.send_email(
        Source='noreply@example.com',
        Destination={'ToAddresses': [email]},
        Message={
            'Subject': {'Data': f'Approval Required for Request {request_id}'},
            'Body': {'Text': {'Data': f'Please approve the request with ID {request_id}.'}}
        }
    )

    return {
        'statusCode': 200,
        'body': 'Approval email sent.'
    }

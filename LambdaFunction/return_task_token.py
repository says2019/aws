import json
import boto3

stepfunctions = boto3.client('stepfunctions')

def handler(event, context):
    task_token = event['taskToken']
    output = {
        "result": "approved"
    }
    stepfunctions.send_task_success(taskToken=task_token, output=json.dumps(output))
    return {
        'statusCode': 200,
        'body': 'Task token returned successfully.'
    }

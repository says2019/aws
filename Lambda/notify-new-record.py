import json

def lambda_handler(event, context):
    print("New record received:", json.dumps(event))
    # Process the new record logic here
    return {
        'statusCode': 200,
        'body': 'New record notification processed successfully.'
    }
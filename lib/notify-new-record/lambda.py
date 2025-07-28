import json


def lambda_handler(event, context):
    # Extract the new record details from the event
    new_record = event.get('new_record')

    # For this example, let's assume we want to print a notification
    print(f"New record added: {new_record}")

    # Optionally, send a notification (e.g., SNS, email, etc.)
    # sns.publish(TopicArn="sns_topic_arn", Message=f"New record added: {new_record}")

    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Notification sent successfully'})
    }

import json

def lambda_handler(event, context):
    print(event)
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Version 1')
    }


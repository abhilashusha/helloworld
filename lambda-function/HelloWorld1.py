import json

def lambda_handler(event, context):
    print(event)
    # TODO implement
    print(" We will try to add new lines 11")


    return {
        'statusCode': 200,
        'body': json.dumps(' This is a new Version and the version is 11')
    }


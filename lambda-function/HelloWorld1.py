import json

def lambda_handler(event, context):
    print(event)
    # TODO implement
    print(" We will try to add new lines 12")


    return {
        'statusCode': 200,
        'body': json.dumps(' This is a new Vers1ion and the version is 113')
    }


import json

def lambda_handler(event, context):
    print("Hello World from Lambda Function")

    return {
        'statusCode': 200,
        'body': json.dumps('Hello From Lambda')
    }
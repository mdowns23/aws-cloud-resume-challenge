import json
import boto3

#retrieve table from dynamo db
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('cloud-resume-challenge-terra')

def lambda_handler(event, context):
    #retrieve viewer item from table
    response = table.get_item(Key={
        'id':'0'
    })
    
    #retrieve views from item
    views = response['Item']['views']
    #update views
    views = views + 1
    print("Views: ", views)
    
    #update views in table
    response = table.put_item(Item={
        'id':'0',
        'views': views
    })
    
    return views
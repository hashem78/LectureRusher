'''
    This is the api script used for the text analysis feature in lecture rusher
'''
import boto3
import json

from pprint import pprint
def lambda_handler(event, context):
    comprehend = boto3.client("comprehend")
    
    # Get sentiment data
    
    sentiment = comprehend.detect_sentiment(Text = event['queryStringParameters']['text'], LanguageCode = "en")['Sentiment']
    
    
    # Get entities
    
    entities = comprehend.detect_entities(Text = event['queryStringParameters']['text'], LanguageCode = "en")
    
    # Format entity data
    
    comercial_items = []
    dates = []
    events= []
    locations = []
    organizations = []
    others = []
    persons = []
    quantities = []
    titles = []
    for entity in entities['Entities']:
        tag = entity['Type']
        word = entity['Text']
        if tag == 'COMMERCIAL_ITEM':
            comercial_items.append(word)
        elif tag == 'DATE':
            dates.append(word)
        elif tag == 'EVENT':
            events.append(word)
        elif tag == 'LOCATION':
            locations.append(word)
        elif tag == 'ORGANIZATION':
            organizations.append(word)
        elif tag == 'OTHER':
            others.append(word)
        elif tag == 'PERSON':
            persons.append(word)
        elif tag == 'QUANTITY':
            quantities.append(word)
        elif tag == 'TITLE':
            titles.append(word)
            
    
    # Get syntax data
    
    syntax = comprehend.detect_syntax(Text = event['queryStringParameters']['text'], LanguageCode = "en")
    
    
     # Format syntax data
    verbs = []
    adjs = []
    nouns = []
    pronouns = []
    interjections= []
    adverbs = []
    for token in syntax['SyntaxTokens']:
        tag = token["PartOfSpeech"]["Tag"]
        word = token["Text"]
        if tag == "INTJ":
            interjections.append(word)
        elif tag == "PRON":
            pronouns.append(word)
        elif tag == "NOUN":
            nouns.append(word)
        elif tag == "VERB":
            verbs.append(word)
        elif tag == 'ADV':
          adverbs.append(word)  
    
    # Build response body
    body = {
                'text':event['queryStringParameters']['text'],
                 "sentiment":sentiment,
                 "entities": {
                         'comercial_items':comercial_items,
                        'dates':dates,
                        'events':events,
                        'locations':locations,
                        'organizations':organizations,
                        'others':others,
                        'persons':persons,
                        'quantities':quantities,
                        'titles':titles,
                 },
                 "syntax":{
                     'verbs':verbs,
                     'adjs':adjs,
                     'nouns':nouns,
                     'pronouns':pronouns,
                     'interjections':interjections,
                     'adverbs':adverbs,
                 }
                }
    
    return {
                "isBase64Encoded": False,
                "statusCode": 200,
                "headers": { "Content-Type": "application/json"},
                "body": json.dumps(body)
           }
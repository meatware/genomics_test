import json


def safeget(dct, *keys):
    for key in keys:
        try:
            dct = dct[key]
        except KeyError:
            return None
    return dct


myjson = """{
   "Records":[
      {
         "eventVersion":"2.1",
         "eventSource":"aws:s3",
         "awsRegion":"eu-west-1",
         "eventTime":"2022-04-27T13:36:00.273Z",
         "eventName":"ObjectCreated:Put",
         "userIdentity":{
            "principalId":"AWS:AIDA3LF53CGOBTWYX7RZC"
         },
         "requestParameters":{
            "sourceIPAddress":"77.101.188.65"
         },
         "responseElements":{
            "x-amz-request-id":"DAM06CQA6JMQMDZT",
            "x-amz-id-2":"gaxKRGR/rmMPv4jMPzS2yI4AxL0rMswFYwOCN6aOjkMp1pG228Vj0En0QHsEqd7nUXTP3rNQM/VIpwCfiY3JEQ9VtnjMWd0k"
         },
         "s3":{
            "s3SchemaVersion":"1.0",
            "configurationId":"exif-ripper-dev-exif-f8ec59914108d38258d2b5c4813c2a22",
            "bucket":{
               "name":"genomics-source-vkjhf87tg89t9fi",
               "ownerIdentity":{
                  "principalId":"APO795FWTHD6Y"
               },
               "arn":"arn:aws:s3:::genomics-source-vkjhf87tg89t9fi"
            },
            "object":{
               "key":"incoming/sls_test_img1.jpg",
               "size":5454955,
               "eTag":"b2bae1d9a042df99728861bb17d8781e",
               "versionId":"2ucsKOhCiWV92Z0xkDUq9C8Lx3QOiFEH",
               "sequencer":"00626946BECE3E6039"
            }
         }
      }
   ]
}"""


data_dict = json.loads(myjson)


print("data_dict", data_dict)

record_list = data_dict.get("Records")
# object_key =  record_list[0]["s3"]["object"]["key"]  #"incoming/sls_test_img1.jpg"

object_key = safeget(record_list[0], "s3", "object", "key")

print("\nobject_key", object_key)

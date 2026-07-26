import os
import time
import boto3

REGION = os.getenv("AWS_REGION")
QUEUE_URL = os.getenv("QUEUE_URL")

sqs = boto3.client(
    "sqs",
    region_name=REGION
)

print("Starting SQS Consumer...")

while True:

    response = sqs.receive_message(
        QueueUrl=QUEUE_URL,
        MaxNumberOfMessages=1,
        WaitTimeSeconds=20,
        VisibilityTimeout=30
    )

    messages = response.get("Messages", [])

    if not messages:
        print("No messages")
        continue

    message = messages[0]

    print(f"Received: {message['Body']}")

    #
    # 실제 업무 처리
    #
    time.sleep(10)

    sqs.delete_message(
        QueueUrl=QUEUE_URL,
        ReceiptHandle=message["ReceiptHandle"]
    )

    print("Deleted")
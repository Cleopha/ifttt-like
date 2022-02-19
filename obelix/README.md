# Obelix Service

## :warning: Requirement

- go >= 1.16

## Setup dev

```sh
docker-compose -f docker-compose.dev.yaml up
```

--> [kafka Manager](http://localhost:9000/)
--> [WorkflowAPI documentation](http://localhost:7777/workflow/)
--> [CredentialAPI documentation](http://localhost:7777/credential/)

## Seed workflow API

```shell
# Open shell in container
docker exec -it ifttt-like-workflow-api-1 /bin/sh

# Install dev dependencies
yarn

# Seed database
yarn db:seed
# yarn run v1.22.17
# $ prisma db seed
# Running seed command `ts-node prisma/seed.ts` ...
# Start seeding database
# Created workflows : [{"id":"4addf05f-77e9-4746-b8e5-80056b254e44","owner":"f1352b9d-3a91-496e-9179-ae9e32429d9a","name":"Workflow 1"},{"id":"a656fcbe-5207-421a-8929-72c92dffa7da","owner":"49eb7f7f-e3c8-4ed4-8078-bed29c1cf135","name":"Workflow 2"}]
# [
#   '{"id":"98265f24-518b-425f-bca1-8f8520993bbe","name":"Google calendar Action","type":"ACTION","action":"GITHUB_ISSUE_OPEN","nextTask":"20f0ecb1-f45a-4f64-87bc-708997d86653","params":{"fields":{"bar":{"numberValue":4},"baz":{"boolValue":true},"foo":{"stringValue":"test"}}},"workflowId":"4addf05f-77e9-4746-b8e5-80056b254e44"}',
#   '{"id":"20f0ecb1-f45a-4f64-87bc-708997d86653","name":"Google calendar Reaction","type":"REACTION","action":"GOOGLE_CALENDAR_NEW_EVENT","nextTask":"2350178f-781c-48ec-b077-b4938ce4586a","params":{"fields":{"bar":{"numberValue":4},"baz":{"boolValue":true},"foo":{"stringValue":"test"}}},"workflowId":"4addf05f-77e9-4746-b8e5-80056b254e44"}',
#   '{"id":"2350178f-781c-48ec-b077-b4938ce4586a","name":"Google calendar Reaction 2","type":"REACTION","action":"GOOGLE_NEW_DOC","nextTask":null,"params":{"fields":{"bar":{"numberValue":4},"baz":{"boolValue":true},"foo":{"stringValue":"test"}}},"workflowId":"4addf05f-77e9-4746-b8e5-80056b254e44"}'
# ]
# [
#   '{"id":"f2efac72-7211-4ffb-b731-cd099765a329","name":"Github pr opened","type":"ACTION","action":"GITHUB_PR_OPEN","nextTask":"24508f67-490b-4725-84f4-75895467ee12","params":{"fields":{"bar":{"numberValue":4},"baz":{"boolValue":true},"foo":{"stringValue":"test"}}},"workflowId":"4addf05f-77e9-4746-b8e5-80056b254e44"}',
#   '{"id":"24508f67-490b-4725-84f4-75895467ee12","name":"Google sheet Reaction","type":"REACTION","action":"GOOGLE_NEW_SHEET","nextTask":"470748ab-164f-4224-ad12-fa04f7b27cb1","params":{"fields":{"bar":{"numberValue":4},"baz":{"boolValue":true},"foo":{"stringValue":"test"}}},"workflowId":"4addf05f-77e9-4746-b8e5-80056b254e44"}',
#   '{"id":"470748ab-164f-4224-ad12-fa04f7b27cb1","name":"Google calendar Reaction 2","type":"REACTION","action":"GOOGLE_CALENDAR_NEW_EVENT","nextTask":null,"params":{"fields":{"bar":{"numberValue":4},"baz":{"boolValue":true},"foo":{"stringValue":"test"}}},"workflowId":"4addf05f-77e9-4746-b8e5-80056b254e44"}'
# ]
# Seed successfully finished
# 
# 🌱  The seed command has been executed.
# Done in 1.71s.
```

You can also [manually add data with Postman](https://blog.postman.com/postman-now-supports-grpc/)
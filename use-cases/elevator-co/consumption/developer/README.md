# Elevator-Co:Consumption:Developer


Postman Collection: [Solace-APIM-UC-Elevator-Co-developer.postman_collection.json](./Solace-APIM-UC-Elevator-Co-developer.postman_collection.json)

### browse api products & specs

- get a list of api products
- get the api product Async Api specs

### register

- register developer username

### create apps

- create developer app from api products
- provide credentials or leave it empty (they are auto generated)
- if approval type = manual, status=pending, waiting for approval from api-team

### get app details

- approval status
- credentials
- environment / messagingProtocols - the connection strings
- permissions - the pub/sub topic patterns permissioned


- get list of AsncApi specs listed in the app


- get the specific AsyncApi spec for each api

### next
Generate code, start subscribing & publishing ...

## Sampe Async API Specs
See [sample-async-apis](./sample-async-apis) for pre-generated, final specs that can be used directly.
These are examples generated using the above steps.

---

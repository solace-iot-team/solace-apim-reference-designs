# Elevator-Co:Exposure:API Team

Postman Collection: [Solace-APIM-UC-Elevator-Co-api-team.postman_collection.json](./Solace-APIM-UC-Elevator-Co-api-team.postman_collection.json)

### get details of environments

  - see which protocols are enabled for each environment

### register / update apis

  - get the AsyncApi Spec from [api-service-developer/api-event-services](./api-service-developer/api-event-services)
  - adjust channel bindings for consumption to the protocols to be supported (e.g. mqtt & http only)
  - copy into body of register api calls

### create api products

- select Apis
- select environments
- select protocols
- select attributes (topic parameter values)
- select approval type

### approve developer apps
- get list of developer apps for approval
- check developer specific attributes (permissions) and adjust accordingly
- approve app for a developer


---

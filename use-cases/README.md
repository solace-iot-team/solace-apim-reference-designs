# Use Cases

## Use Case Organization

Each use case has two main sub-directories: **consumption** and **exposure**.

These contain:
* **consumption:**
  - developer - the role of the developer
* **exposure:**
  - _**api-service-developer**_ - the role of the service developer creating api event services
  - _**api-team**_ - the role of the api team, creating & managing api products
  - _**operations**_ - the role of the operations team, creating & managing environments

The Postman Collections in the various directories/roles are examples of the OpenAPI calls to the
[Solace Platform API](http://ec2-18-157-186-227.eu-central-1.compute.amazonaws.com:3000/api-explorer/#/)
most relevant for that role:
- **operations** - manage orgs and environments
- **exposure/api-team** - register AsyncApis, create Api Products, approve developer Apps
- **consumption/developer** - register as developer, browse Api Products, create Apps, download final AsyncApi spec

Example structure for use case **elevator-co**:

````
└── elevator-co
    ├── consumption
    │   └── developer
    │       ├── Solace-APIM-UC-Elevator-Co-developer.postman_collection.json
    │       └── sample-async-apis
    │           ├── api-maintenance.async-api-spec.json
    │           └── api-status-update.async-api-spec.json
    └── exposure
        ├── api-service-developer
        │   └── api-event-services
        │       ├── common-schemas
        │       │   ├── common.json
        │       ├── maintenance
        │       │   ├── ApiEventService_maintenance.async-api-spec.yml
        │       │   ├── maintenance.schema.json
        │       │   ├── sample-messages
        │       │   │   ├── maintenance.payload.sample.1.json
        │       │   └── send.maintenance.sh
        │       └── status-update
        │           ├── ApiEventService_status_update.async-api-spec.yml
        │           ├── sample-messages
        │           │   ├── status_update.payload.sample.1.json
        │           ├── send.status_update.sh
        │           └── status_update.schema.json
        ├── api-team
        │   ├── Solace-APIM-UC-Elevator-Co-api-team.postman_collection.json
        │   ├── maintenance
        │   │   └── Api_maintenance.async-api-spec.yaml
        └── operations
            └── Solace-APIM-UC-Elevator-Co-Operations.postman_collection.json
````

## Setup Solace Development Broker

Create a Solace Service and make a note of the service-id.

## Generate a Solace Cloud API Token

Permissions:
  - Organization Services:
    - Get Services
  - Event Portal
    - Event Portal Read

Copy & save the token. It is needed to configure the Postman Environment.

## Postman Collections

Import the various collections into Postman.

### Create Postman Environment

All Postman Collections require the following environment variables:

  - name: e.g. `My-Account-APIM-Test`

Variables:
- **baseUrl**: `http://ec2-18-157-186-227.eu-central-1.compute.amazonaws.com:3000/v1`
- **solace-apim-admin-user**: {the admin user}
- **solace-apim-admin-pwd**: {the admin password}
- **solace-apim-api-user**: {the api user}
- **solace-apim-api-password**: {the api password}
- **solaceCloudApiToken**: `{solace cloud api token}`
- **org**: `{your-unique-ord-id}`
- **devEnv_serviceId**: the service id of the Solace Cloud broker, e.g. `1i5g7tif6z8p`
- **devEnv_name**: the name of the development environment in the api, e.g. `our-dev-env`
- **prodEnv_serviceId**: the service id of the Solace Cloud broker, e.g. `1i5g7tif6z8x`
- **prodEnv_name**: the name of the development environment in the api, e.g. `our-prod-env`



---

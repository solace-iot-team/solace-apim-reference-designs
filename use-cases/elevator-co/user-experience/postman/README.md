# User Experience for Use Case: Elevator-Co

[Solace Platform API - Open API Doc](http://ec2-18-157-186-227.eu-central-1.compute.amazonaws.com:3000/api-explorer/#/)

## Setup Solace Development Broker

Create a Solace Service and make a note of the service-id.

## Generate a Solace Cloud API Token

Permissions:
  - Organization Services:
    - Get Services
  - Event Portal
    - Event Portal Read

Copy & save.

## Create Postman Environment

  - name: e.g. `My-Account-APIM-Test`

Variables:
  - **solaceCloudApiToken**: `{solace cloud api token}`
  - **devEnv_serviceId**: the service id of the Solace Cloud broker, e.g. `1i5g7tif6z8p`
  - **devEnv_name**: the name of the development environment in the api, e.g. `our-dev-env`
  - **baseUrl**: `http://ec2-18-157-186-227.eu-central-1.compute.amazonaws.com:3000/v1`
  - **solace-apim-api-user**: {the api user}
  - **solace-apim-api-password**: {the api password}
  - **org**: `{your-unique-ord-id}`


## Import Postman Collection

Collection: [**Solace-APIM-UC-Elevator-Co.postman_collection.json**](./Solace-APIM-UC-Elevator-Co.postman_collection.json)

Select Environment: e.g. `My-Account-APIM-Test`


## Run Postman

For ease of use, these pre-configured AsyncAPI specs are contained in the collection as variables:
  - **alarmsAndFaultsApiSpec**: [alarms-and-faults.async-api-spec.yaml](../../event-apps/alarms-and-faults/alarms-and-faults.async-api-spec.yaml)
  - **maintenanceApiSpec**: [maintenance.async-api-spec.yaml](../../event-apps/maintenance/maintenance.async-api-spec.yaml)
  - **usageApiSpec**: [usage.async-api-spec.yaml](../../event-apps/usage/usage.async-api-spec.yaml)


### Create Organization & Environments

- **management:**
  - run: **all**
    - creates the organization
    - creates the development environment - the association with the Development Broker

### Create API Products

- **publisher:**
  - run: **all**
    - fetches the AsyncAPI specs for alarms-and-faults, maintenance, usage from Event Portal
    - creates the apis from the AsyncAPI specs
    - creates API products for alarms-and-faults, maintenance, usage

### Create Apps

- **consumer-create-apps:**
  - run: **all**
    - creates developers
    - creates apps for developers

### Approve Apps

- **approver:**
  - run:**approve dev-1 app:**
    - restricts the event stream to: `hilton` in `de` in `munich and cologne`
    - sets status=`approved`

### Use Apps
- **consumer-use-apps:**
  - run: **GET app details: dev-1-elevator-alarms-and-faults-maintenance**
    - returns app details
  - run: **GET app details: app details: dev-2-elevator-usage**
    - returns app details

### Start Clean
- **helpers:**
  - run: **delete Org:**
    - deletes the entire org and everything in it

## Using Solace Event Portal
### Setup Solace Event Portal

Create the schemas, events, event apps:

* [alarms-and-faults](../../event-apps/alarms-and-faults)
* [maintenance](../../event-apps/maintenance)
* [usage](../../event-apps/usage)

### Run Postman

- **EventPortal:**
  - run: **all**
    - retrieves the AsyncAPI specs for usage, alarms & faults, maintenace from event portal
---

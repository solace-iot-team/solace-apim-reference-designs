# Use Case: Elevator-Co - Postman Walkthrough Solace Platform API Usage

[Solace Platform API - Open API Doc](http://ec2-18-157-186-227.eu-central-1.compute.amazonaws.com:3000/api-explorer/#/)

## Setup Solace Event Portal

Create the schemas, events, event apps:

* [alarms-and-faults](../../event-apps/alarms-and-faults)
* [maintenance](../../event-apps/maintenance)
* [usage](../../event-apps/usage)

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

### Create Organization

- **management:**
  - run: **create Org**

### Create API Products

- **publisher:**
  - run: **all**
    - fetches the AsyncAPI specs for alarms-and-faults, maintenance, usage from Event Portal
    - creates the apis from the AsyncAPI specs
    - creates the development environment - the association with the Development Broker
    - creates API products for alarms-and-faults, maintenance, usage

### Create Apps

- **consumer-create-apps:**
  - run: **all**
    - creates developers
    - creates apps for developers

### Approve Apps

- **approver:**
  - TODO:
  - get a list of apps pending approval
  - send approved

### Use Apps
- **consumer-use-apps:**
  - run: **GET app details: dev-1-elevator-alarms-and-faults-maintenance**
    - returns app details
  - run: **GET app details: app details: dev-2-elevator-usage**
    - returns app details


---

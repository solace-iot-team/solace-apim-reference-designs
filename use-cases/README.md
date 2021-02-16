# Use Cases

[Solace Platform API - Open API Doc.](http://ec2-18-157-186-227.eu-central-1.compute.amazonaws.com:3000/api-explorer/#/)

## Setup Solace Development Broker

Create a Solace Service and make a note of the service-id.

## Generate a Solace Cloud API Token

Permissions:
  - Organization Services:
    - Get Services
  - Event Portal
    - Event Portal Read

Copy & save.

## Postman Collections

Each sub-directory (where applicable) has a Postman Collection that incorporates the Solace Platform API calls required
to run as part of the API Management workflow:
- [operations](./operations) - manage orgs and environments
- [exposure/api-team](./exposure/api-team) - register AsyncApis, create Api Products, approve developer Apps
- [consumption/developer](./consumption/developer) - register as developer, browse Api Products, create Apps, download final AsyncApi spec

### Create Postman Environment

All Postman Collections require the following environment variables:

  - name: e.g. `My-Account-APIM-Test`

Variables:
  - **solaceCloudApiToken**: `{solace cloud api token}`
  - **devEnv_serviceId**: the service id of the Solace Cloud broker, e.g. `1i5g7tif6z8p`
  - **devEnv_name**: the name of the development environment in the api, e.g. `our-dev-env`
  - **prodEnv_serviceId**: the service id of the Solace Cloud broker, e.g. `1i5g7tif6z8x`
  - **prodEnv_name**: the name of the development environment in the api, e.g. `our-prod-env`
  - **baseUrl**: `http://ec2-18-157-186-227.eu-central-1.compute.amazonaws.com:3000/v1`
  - **solace-apim-api-user**: {the api user}
  - **solace-apim-api-password**: {the api password}
  - **org**: `{your-unique-ord-id}`



---

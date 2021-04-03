# Bootstrap Use Case: Elevator Company

## Overview
Pipeline ([see src/index.ts](./src/index.ts)):

- initialize the client library with the management & api user usernames & passwords
- delete the organization
- create the organization
- register Solace Cloud Services for `prod` and `dev` (the API Gateways) with the organization
- create the mainteanace API ([ApiMaintenance.async-api-spec.yml](./asyncapi-specs/ApiMaintenance.asyncapi-spec.yml))
- create a `dev` and `prod` API Product with the API
- register two developers `dev1@maintenance-co-a.de` and `dev2@maintenance-co-b.com`
- create a `dev` and `prod` app for each developer
- approve & set different permissions for both `prod` apps

## Prerequisites

- Solace Cloud API Token & optional separate Event Portal API URL & Token - [see README for details](https://github.com/solace-iot-team/solace-apim-reference-designs).
- 2 services in Solace Cloud to act as the API Gateways, `production` and `development`

## Configure

Set the environment variables defined in `template.source.env.sh`.

````bash
$ cp template.source.env.sh source.env.sh

# edit the values ...

$ source source.env.sh

# check:
$ env | grep APIM_BOOTSTRAP
````

## Run
### Local Platform API System
[See here for more details.](./apim-system/local)

**standup:**
````bash
$ ./bootstrap.apim-system.local.sh
````
**teardown:**
````bash
$ ./teardown.apim-system.local.sh
````

### Bootstrap Use Case on Platform API System

````bash
$ npm install
$ npm start
````

### View in Demo Portal

coming soon ...

---

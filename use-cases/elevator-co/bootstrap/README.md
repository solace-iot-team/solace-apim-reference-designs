# Bootstrap Use Case: Elevator Company

## Overview
Bootstrap Pipeline ([see src/index.ts](./src/index.ts)):

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
### Local System
[See here for more details.](./apim-system/local)

**standup:**
````bash
$ ./standup.apim-system.local.sh
````

**connect your browser to the `platform-api-server`:**
````
http://localhost:{$APIM_SYSTEM_PLATFORM_API_SERVER_PORT}
default: http://localhost:9090
````

**teardown:**
````bash
$ ./teardown.apim-system.local.sh
````

### Bootstrap Use Case

````bash
$ npm install
$ npm start
````

### View in Demo Portal

**connect your browser to the `apim-demo-portal`:**
````
http://localhost:{$APIM_SYSTEM_DEMO_PORTAL_SERVER_PORT}
default: http://localhost:9091

login with:
  user:     {$APIM_SYSTEM_PLATFORM_API_SERVER_ORG_API_USER}
  password: {$APIM_SYSTEM_PLATFORM_API_SERVER_ORG_API_USER_PWD}
defaults:
  user:     elevator_co_admin
  password: elevator_co_admin_123!
````


---

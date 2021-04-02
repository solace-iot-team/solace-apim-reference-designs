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

- Running instance of the Platform-Api Server
- Solace Cloud account with rights to create a token
- 2 services in Solace Cloud to act as the API Gateways `prod` and `dev`

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
### Bootstrap local APIM System
[See here for more details.](./apim-system/local)
````bash
$ ./bootstrap.apim-system.local.sh
````

````bash
$ ./teardown.apim-system.local.sh
````

### Bootstrap Use Case

````bash
$ npm install
$ npm start
````

### View in Demo Portal

coming soon ...

---

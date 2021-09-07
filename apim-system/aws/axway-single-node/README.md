# Docker Compose Template for Axway Central 

Sets up all components of Solace API-Management connector and Solace-Axway-Amplify-Agent using docker-compose:

* Solace Connector Services
* Mongodb-Database Backend for Solace Connector Services
* Sample/Demo Portal Application for Solace Connector Services
* Solace-Axway-Amplify-Agent 
* NGINX as reverse proxy for Solace Connector Service and Sample/Demo Portal Application

This folder containers
* a docker-compose file, 
* a sample .env that you can adjust to your environment
* a dummy key for JWT verification
* a sample file user registry
* nginx configuration file

## High level architecture 

![Solace Axway Demo Setup](https://github.com/solace-iot-team/solace-apim-reference-designs/blob/develop/apim-system/aws/axway-single-node/solace-axway-demo-setup.png)

## Files on Host Systems

Some configuration files and data directories are mounted from the host system:

* MongoDB Data Folder - please identify a suitable location in your local file system, configured via the variable `MONGODB_DATA_MOUNT_PATH`
* APIM Connector - please identify a suitable location for configuration files, configured via the variable `PLATFORM_DATA_MOUNT_PATH`
* nginx front end server - please identify a suitable location for nginx.conf file, configured via the variable `NGINX_CONF_LOCATION`

For information on how to set these environment variables please see below.


## Preparing the APIM Connector Configuration Files

The Connector requires access to two configuration files:
* Key file used for JWT verification: this MUST be provided even if only using Basic Auth. A ``dummy.pem` file is provided.
* A file user registry in JSON format, a sample called `organization_users.json` is provided. 

Both of these files must be copied into the directory you intend to mount into the APIM Connector container (environment variable `PLATFORM_DATA_MOUNT_PATH`)

## Configuring the file user registry

At a minimum please adjust the passwords in the `organization_users.json`. It contains examples of entries for a connector admin (platform-admin) and an organization admin (org-admin).
Users can have one or both roles.

Take note of both a user/password with `platform-admin` and `org-admin` role as you need these to configure the credentials the sample portal uses to connect.

You can add users to the array of users in the `organization_users.json`. It contains an example:

```json
	"example": {
    "password": "changeme",
    "roles": [
      "org-admin"
    ]
  }

```

The user registry is reloaded periodically so you can add more users as required.

## Prerequisits of the Solace-Axway-Amplify-Agent

The Solace-Axway-Amplify-Agent establishes a HTTP-Connection (polling) to Axway-Central. 

You have to obtain these configuration details from Axway Central self-service portal and provide them as environment variables (see section Configuration)

* your Axway-Central HTTP Endpoint (e.g. 'https://central.eu-fr.axway.com')
* your Axway-Central Organization-Id
* your Axway-Central Environment name
* your Axway-Central Service-Client-Id
* your Axway-Central Service-Client Public and Private Key
  * to convert the PEM file into a single-line format you can use `awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' cert-name.pem` and copy the result int `.env` file. 


## Configuring the Environment Variables

The `.env` file contains an example configuration of environment variables.

Environment variables are documented in the file.

You can duplicate this file and adjust it for your environment.

## Running docker-compose

By default docker-compose picks up the `.env` file. Alternatively you can point docker-compose to the env file you want to use (e.g. if you cloned the original file and made your adjustments in the copy)

Here's an exmaple command using a custom `env.local` environment file.
 
```shell
docker-compose -f docker.compose.yml --env-file ./env.local up -d
```
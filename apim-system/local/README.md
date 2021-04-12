# APIM System: Local

## Prerequisites

- docker
- docker-compose

## Configure

### Create an Organization User file and Mount Directory
Example:
````bash
mkdir ./tmp/platform-api-server-data
cd ./tmp/platform-api-server-data
vi organization_users.json
# add users, see Example below
````
Example:
````json
{
  "{organization-A-admin-username}": "{password}",
  "{organization-B-admin-username}": "{password}"
}
````

### Configuration

Set the environment variables defined in `template.source.env.sh`.

```bash
cp template.source.env.sh source.env.sh

# edit the values or keep defaults

source source.env.sh

# check:
env | grep APIM_SYSTEM
```

## Run

Starts the system in local docker containers using [docker-compose.yml](./docker-compose.yml).
- mongo db
- platform-api-server
- apim-demo-portal


**start:**
```bash
./start.system.sh
```
**checks:**
```bash
docker ps
docker logs apim-system-platform-api-server
```
**connect your browser to the `platform-api-server`:**
````
http://localhost:{$APIM_SYSTEM_PLATFORM_API_SERVER_PORT}
default: http://localhost:9090
````
**connect your browser to the `apim-demo-portal`:**
````
http://localhost:{$APIM_SYSTEM_DEMO_PORTAL_SERVER_PORT}
default: http://localhost:9091

login with:
  user:     {$APIM_SYSTEM_PLATFORM_API_SERVER_ORG_API_USER}
  password: {$APIM_SYSTEM_PLATFORM_API_SERVER_ORG_API_USER_PWD}
defaults:
  user:     orgadmin
  password: orgadmin123!

````

**stop:**
```bash
./stop.system.sh
```


---

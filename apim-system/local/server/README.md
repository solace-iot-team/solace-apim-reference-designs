# APIM System: Local Platform API Server

## Prerequisites

- docker
- docker-compose

## Configure

### Create an Organization User file
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

# edit the values ...

source source.env.sh

# check:
env | grep APIM_SYSTEM
```

## Run

**start:**
```bash
./start.server.sh
```
**check logs:**
```bash
docker logs {container-name}
```

**stop:**
```bash
./stop.server.sh
```


---

# APIM System: Local Platform API Server

## Prerequisites

- docker
- docker-compose

## Configure

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

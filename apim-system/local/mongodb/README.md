# APIM System: Local Mongo DB

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

```bash
./start.mongo.sh
```

```bash
./stop.mongo.sh
```


---

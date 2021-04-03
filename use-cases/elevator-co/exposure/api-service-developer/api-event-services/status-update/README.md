# Elevator-Co: Exposure:API Service Developer:API Event Service:Status Update

## Topic Schema

**event_type**="status"

`apim/elevator-co/api/V1/json/status/{tracking_id}`

**Topic Examples:**
- `apim/elevator-co/api/V1/json/status/123ABCxyz`

## API Event Service Simulator

Requires:
- python 3
- jsonschema
- jq


````bash
pip3 install jsonschema
# REST connection details
export SOLACE_APIM_REST_USERNAME="e.g. solace-cloud-client"
export SOLACE_APIM_REST_PASSWORD="xxxx"
export SOLACE_APIM_REST_URL="http://xxxx.messaging.solace.cloud:9000"

./send.status_update.sh
````

**Output:**
````bash
ls ./sample-messages/*.json
````

## Topic Schema Subscribe

`apim/elevator-co/api/V1/json/{event_type}/{tracking_id}`

### Fixed Parameters
see above.

### Event-App Parameters

  - **event_type**: event type. ['status']

### Run-Time Parameters

  - **tracking_id**: a unique and valid tracking_id as received in event payload.header.tracking_id
    - service will ignore tracking ids that are not valid


---

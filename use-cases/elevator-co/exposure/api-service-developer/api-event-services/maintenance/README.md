# Elevator-Co: Exposure:API Service Developer:API Event Service:Maintenance

### Topic Template

**event_type**="maintenance"

`apim/elevator-co/api/V1/json/{resource_region_id}/elevator/maintenace/{resource_type}/{resource_id}`

### Examples
- `apim/elevator-co/api/V1/json/fr/elevator/maintenace/elev-make-1/elevator-id-1`
- `apim/elevator-co/api/V1/json/de/elevator/maintenace/elev-make-1/elevator-id-2`

### Simulator

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

./send.maintenance.sh
````

Output:
````bash
ls ./sample-messages/*.json
````

---

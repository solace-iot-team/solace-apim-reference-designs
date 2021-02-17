# Elevator-Co: Event-Apps: Predictive Maintenance

## Topic Template

`apim/elevator-co/data-product/V1/json/elevator/{event_type}/{resource_org_id}/{resource_region_id}/{resource_sub_region_id}/{resource_site_id}/{resource_type}/{resource_id}`

### Fixed Parameters

  - **apim/elevator-co**: domain
  - **data-product**: fixed
  - **V1**: version
  - **json**: payload content type
  - **elevator**: asset type

### Event-App Parameters

  - **event_type**: event type

### Run-Time Parameters

  - **resource_org_id**: organization that owns the asset, e.g. hilton, mariott
  - **resource_region_id**: region the resource is installed. examples: country: FR, DE.
  - **resource_sub_region_id**: sub-region within the region the resource is installed. examples: city: munich, paris, milan
  - **resource_site_id**: site where the resource is installed.
  - **resource_type**: the type of the resource, e.g. type of elevator
  - **resource_id**: the unique id of the resource, e.g. ABXD32

## Maintenance
**event_type**="maintenance"
### Topic Template
`apim/elevator-co/data-product/V1/json/elevator/maintenance/{resource_org_id}/{resource_region_id}/{resource_sub_region_id}/{resource_site_id}/{resource_type}/{resource_id}`
### Examples
- `apim/elevator-co/data-product/V1/json/elevator/maintenance/hilton/FR/paris/opera/elev-make1/elevator-id-1`

### Simulator
````bash
# requires python
pip install jsonschema
# REST connection details
export SOLACE_APIM_REST_USERNAME="e.g. solace-cloud-client"
export SOLACE_APIM_REST_PASSWORD="xxxx"
export SOLACE_APIM_REST_URL="http://xxxx.messaging.solace.cloud:9000"

./send.maintenance.sh
````


---

# Car-Co:Exposure:API Service Developer

Develop API Event Services based on the raw telemetry data from connected vehicles.

## Develop API Event Services

### Publish Services
- consumption
- safety alerts
- failure alerts

## Topic Schema Publish

`apim/car-co/api/V1/json/{region_id}/{make}/{model}/{vin}/{event_type}`

### Fixed Parameters

  - **apim/car-co**: domain
  - **api**: fixed
  - **V1**: version
  - **json**: payload content type

### Event-App Parameters

- **region_id**: the region.
- **make**: the make of the vehicle
- **model**: teh model of the vehicle
- **vin**: the unique VIN of the vehicle
- **event_type**: the event type. ['consumption', 'safety_alert', 'failure_alert']


---

# Elevator-Co:Exposure:API Service Developer

Develops API Event Services based on the raw telemetry data from elevators.

## Develop API Event Services

_**Note: these are the reverse / opposites of the API Products published for consumption.**_

### Publish
- alarms-and-faults
- maintenance
- usage

### Subscribe
- status

## Create AsyncAPI Spec
- payload schemas
- topic schemas
  - (including valid values for topic parameters)
- channel bindings
  - protocol
    - smf
    - quality of service parameters

## Topic Template

`apim/elevator-co/api/V1/json/{resource_region_id}/{equipment_type}/{event_type}/{resource_type}/{resource_id}`

### Fixed Parameters

  - **apim/elevator-co**: domain
  - **api**: fixed
  - **V1**: version
  - **json**: payload content type

### Event-App Parameters

  - **event_type**: event type. ['maintenace', 'usage', 'alarm', 'fault']

### Run-Time Parameters

  - **resource_region_id**: region the resource is installed. ['fr', 'de']
  - **equipment_type**: asset type, ['elevator', 'escalator']
  - **resource_type**: the type of the resource, e.g. type of elevator. ['elev-make-1', 'elev-make-2']
  - **resource_id**: the unique id of the resource, e.g. ABXD32

---

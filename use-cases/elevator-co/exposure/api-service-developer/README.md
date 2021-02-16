# Elevator-Co:Exposure:API Service Developer

Develops API Event Services based on the raw telemetry data from elevators.

## Develop API Event Services

### Publish Services
- alarms-and-faults
- maintenance
- usage

### Subscribe Services
- status

## Create AsyncAPI Spec

**Note: Create AsyncAPI Spec using reverse/opposite for pub<-->sub.**

Contains:
- **payload schemas**
- **channel (topic) parameters**
  - including all possible values where required for permissioning
- **channel bindings**
  - list of possible bindings
  - service developed according to `least common denominator`
  - here: **http**
    - topic in the payload header
    - no use of message properties, attributes, or other headers
    - guaranteed messaging
  - therefore:
    - service can be used with these protocols
      - http, mqtt, jms, smf

## Topic Schema Publish

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

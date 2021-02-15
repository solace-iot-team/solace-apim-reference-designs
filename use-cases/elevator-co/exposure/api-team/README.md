# Elevator-Co:Exposure:API Team

- Receives API Event Services AsyncAPI Spec from API Service Developer.
- Creates AsyncAPI Spec for consumption (note: the reverse operations)
  - assigns channel bindings for consumption
- Bundles APIs (1 API = 1 AsyncAPI Spec) into API Products
- Assigns Environments to API Products (the physical instances of the runtime gateway=Solace broker)
- Assigns protocols to API Products (based on capabilities of Environments)
- Publishes API Products for consumption


## Create AsyncAPI Spec for Consumption

_**Note: these are the reverse / opposites of the API Event Services.**_

### Subscribe
- alarms-and-faults
- maintenance
- usage

### Publish
- status

### API AsyncAPI Spec
- payload: same as incoming API Event Service AsyncAPI spec
- topic schemas: same as incoming API Event Service AsyncAPI spec
- channel bindings:
  - (takes quality of service hints from API Event Service AsyncAPI spec)
  - http
  - mqtt
  - quality of service parameters

## Create API Products
- bundle 1 or many APIs (=AsyncAPI spec) into products
- adds approval type:
  - manual, auto
- adds valid values for topic parameters
  - e.g. region_id = fr, de, us, ch
- protocols for consumption
  - http
  - mqtt

## Approves Developer Apps
- checks specific access permissions for developer
- optional: changes topic parameter values (attributes) for developer based on contract
- approves developer app

---

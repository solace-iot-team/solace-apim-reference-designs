[![use-case-tests](https://github.com/solace-iot-team/solace-apim-reference-designs/actions/workflows/use-case-tests.yml/badge.svg)](https://github.com/solace-iot-team/solace-apim-reference-designs/actions/workflows/use-case-tests.yml)

# Reference Designs & Examples for Solace AysncAPI Management Integration.

[Concepts](./Concepts.md) |
[Issues](https://github.com/solace-iot-team/solace-apim-reference-designs/issues) |
[Discussions](https://github.com/solace-iot-team/solace-apim-reference-designs/discussions)

## Prerequisites
In order to run the examples & use cases you need the following:
- a Solace Cloud Account and the rights to generate API Tokens
- an instance of the API Management Connector

## Generate a Solace Cloud API Token

Permissions:
  - Organization Services:
    - Get Services
  - Event Portal
    - Event Portal Read

Copy & save the token. It is needed to configure the use case scripts.

## Provision an Instance of the API Management Connector

* [Local system in docker containers](./apim-system/local)
* [System in AWS] - coming soon

### Use Cases

The Use Case folders contains designs, sample AsyncAPI specs, bootstrap cli examples and more to showcase a particular use case.

* [Use Case: Elevator-Co](./use-cases/elevator-co)
* [Use Case: Car-Co](./use-cases/car-co)

---

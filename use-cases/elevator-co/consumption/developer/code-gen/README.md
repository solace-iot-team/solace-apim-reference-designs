# ElevatorCo:Consumption:Developer:Code Generation


[https://github.com/asyncapi/generator](https://github.com/asyncapi/generator)

````bash
npm install -g @asyncapi/generator
````

````bash
ag {async-api-spec} @asyncapi/nodejs-template -o {app-name} -p server={server-name}

# using a standard template
ag ../sample-async-apis/api-maintenance.async-api-spec.json @asyncapi/nodejs-template -o apps/maintenance-repo -p server=dev-mqtt

# using a local template
ag ../sample-async-apis/api-maintenance.async-api-spec.json ../../../../../../asyncapi/nodejs-template -o apps/maintenance-local -p server=dev-mqtt
# with a sym link
ag ../sample-async-apis/api-maintenance.async-api-spec.json ./local-template -o apps/maintenance-local -p server=dev-mqtt
````

````bash
# experimental
ag ../sample-async-apis/experimental/api-maintenance-simple.async-api-spec.yml ./local-template -o apps/maintenance-local -p server=dev-mqtt
````

---

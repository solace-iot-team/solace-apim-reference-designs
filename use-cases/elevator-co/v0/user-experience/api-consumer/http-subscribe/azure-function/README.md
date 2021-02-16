# Elevator-Co: User: Api-Consumer: HTTP Subscribe: Azure Function

This is the webhook the Api-Consumer/Developer provides to the Api to be called when an event occurs.

## Deploy Azure Function
Deploy a pre-packaged Azure Function with an HTTP trigger that writes incoming messages to a Blob Storage.

See also: [Solace Integration: RDP to Azure Functions](https://github.com/solace-iot-team/solace-int-rdp-az-funcs).

### Prerequisites

* Azure Account
* Azure CLI
* bash
* [jq](https://stedolan.github.io/jq/download/)

### Login to Azure
````bash
az login
# if you have more than 1 subscription:
az account set --subscription {YOUR-SUBSCRIPTION-NAME-OR-ID}
````

### Get the Release Assets of the Azure Function

Downloads the Azure function Zip package from [Solace Integration: RDP to Azure Functions](https://github.com/solace-iot-team/solace-int-rdp-az-funcs)

````bash
./1.download-azure-function-assets.sh
# check the release assets
ls ./tmp/release
````

### Create Azure Resources

#### Settings
````bash
cp ./template.settings.json settings.json

vi settings.json
  # change values
  # note: ensure you choose a unique name for the project

# Note: to find out the Azure locations supported in your subscription:
az appservice list-locations --sku F1
````

Example `settings.json`:
````json
{
    "projectName": "apim-rdp-func-xxx",
    "azLocation": "West Europe",
    "functionAppAccountName": "apim-rdp-func-xxx",
    "rdp2blobFunction": {
        "functionName":"solace-apim-2-blob",
        "dataLakeStorageContainerName": "solaceapim2blob",
        "dataLakeFixedPathPrefix": "solace/apim/elevator-co"
    }
}
````


#### Create Azure Resources and Deploy Function

- creates Azure resource group with:
  - function app with function
  - app service plan
  - storage account

````bash
./2.create.deploy.azure.sh
````

### Display App Webhook Settings

Use these settings when registering your app: `az_webhook_function.webHook`.

````bash
./3.get.apim-app-webhook-settings.sh
````
Example `webhook.settings.json`:
````json
{
  "az_webhook_function": {
    "webHook": {
      "uri": "https://{name}.azurewebsites.net:443/api/solace-rdp-2-blob?code={code}&path=test&pathCompose=withTime",
      "method": "POST",
      "mode": "parallel"
    },
    "az_func_code": "{code}",
    "az_func_host": "{name}.azurewebsites.net",
    "az_func_port": "443",
    "az_func_tls_enabled": true,
    "az_func_trusted_common_name": "*.azurewebsites.net"
  }
}
````
### Test Azure Function Manually
- send POST requests to the Azure function
- go to the Azure portal, Blob Storage: `solaceintrdpdatalake` to see the blob files

````bash
./4.test.azure-function.sh
````

### Update App with Webhook Details

Use the Postman Collection:

* Update: `Solace-APIM-UC-Evevator-Co/consumer-update-apps-webhook`
* Get Details: `Solace-APIM-UC-Evevator-Co/consumer-use-apps`

### Send Events

* Use `send.*.sh` simulators in the `event-apps` directories to send events to the broker.
* Check Azure Blog Storage to see the events


### Delete Azure Deployment
Convenience script to delete the deployment.
````bash
./x.delete.deployment.azure.sh
````

---

#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);

##############################################################################################################################
# Settings

  WORKING_DIR="$scriptDir/tmp"

  deploymentDir="$WORKING_DIR/azure-deployment"
  settingsTemplateFile="$scriptDir/scripts/webhook.settings.template.json"
  settingsFile="$deploymentDir/webhook.settings.json"
  funcAppInfoFile="$deploymentDir/rdp2blob.func-app-info.output.json"
  certName="BaltimoreCyberTrustRoot.crt.pem"

if [ ! -f "$funcAppInfoFile" ]; then echo ">>> ERROR: file not found: $funcAppInfoFile"; exit 1; fi

##############################################################################################################################
# Run

echo ">>> Extract API Webhook settings ..."

echo " >>> download certificate ..."
curl --silent -L "https://cacerts.digicert.com/$certName" > $deploymentDir/$certName
if [[ $? != 0 ]]; then echo ">>> ERROR:$runScript"; echo; exit 1; fi
echo " >>> done."

echo " >>> collect settings ..."

funcAppInfoJSON=$(cat $funcAppInfoFile | jq . )
export rdp2Blob_azFuncCode=$( echo $funcAppInfoJSON | jq -r '.functions."solace-rdp-2-blob".code' )
export rdp2Blob_azFuncHost=$( echo $funcAppInfoJSON | jq -r '.defaultHostName' )
export hostDomain="*."${rdp2Blob_azFuncHost#*.}
export certFile="$deploymentDir/$certName"
# fixed values
export rdp2Blob_azFuncPort=443
export rdp2Blob_azFuncMode="parallel"
export rdp2Blog_azFuncName="solace-rdp-2-blob"

# compose uri
functionBaseUrl="https://$rdp2Blob_azFuncHost:$rdp2Blob_azFuncPort/api/$rdp2Blog_azFuncName?code=$rdp2Blob_azFuncCode"
functionParams="path=test&pathCompose=withTime"
export rdp2Blob_azFuncUri="$functionBaseUrl&$functionParams"
# merge into template
settingsJSON=$(cat $settingsTemplateFile | jq . )
settingsJSON=$(echo $settingsJSON | jq ".az_webhook_function.az_func_code=env.rdp2Blob_azFuncCode")
settingsJSON=$(echo $settingsJSON | jq ".az_webhook_function.az_func_host=env.rdp2Blob_azFuncHost")
settingsJSON=$(echo $settingsJSON | jq ".az_webhook_function.az_func_trusted_common_name=env.hostDomain")
settingsJSON=$(echo $settingsJSON | jq ".az_webhook_function.az_func_tls_enabled=true")
settingsJSON=$(echo $settingsJSON | jq ".az_webhook_function.az_func_port=env.rdp2Blob_azFuncPort")
settingsJSON=$(echo $settingsJSON | jq ".az_webhook_function.webHook.uri=env.rdp2Blob_azFuncUri")
settingsJSON=$(echo $settingsJSON | jq ".az_webhook_function.webHook.mode=env.rdp2Blob_azFuncMode")

echo $settingsJSON | jq . > $settingsFile

echo " >>> done."

echo " >>> Certificate: $deploymentDir/$certName"
echo " >>> Settings: $settingsFile"
cat $settingsFile | jq .

###
# The End.

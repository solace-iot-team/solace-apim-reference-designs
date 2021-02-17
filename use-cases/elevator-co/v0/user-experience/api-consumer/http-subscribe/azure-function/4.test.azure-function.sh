#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);

##############################################################################################################################
# Settings

  WORKING_DIR="$scriptDir/tmp"

  deploymentDir="$WORKING_DIR/azure-deployment"
  settingsFile="$deploymentDir/webhook.settings.json"

if [ ! -f "$settingsFile" ]; then echo ">>> ERROR: file not found: $settingsFile"; exit 1; fi

##############################################################################################################################
# Extract settings

  settingsJSON=$(cat $settingsFile | jq . )
  az_func_host=$( echo $settingsJSON | jq -r '.az_webhook_function.az_func_host' )
  az_func_port=$( echo $settingsJSON | jq -r '.az_webhook_function.az_func_port' )
  az_func_name=$( echo $settingsJSON | jq -r '.az_webhook_function.az_func_name' )
  az_func_code=$( echo $settingsJSON | jq -r '.az_webhook_function.az_func_code' )

  functionBaseUrl="https://$az_func_host:$az_func_port/api/$az_func_name?code=$az_func_code"


  topics=(
  # hilton, france, paris, opera
    "apim/elevator-co/data-product/V1/json/elevator/critical-alarm/hilton/fr/paris/opera/elevator-make-ABC/elevator-id-1"
    "apim/elevator-co/data-product/V1/json/elevator/critical-alarm/hilton/fr/paris/opera/elevator-make-ABC/elevator-id-2"
    "apim/elevator-co/data-product/V1/json/elevator/critical-alarm/hilton/fr/paris/opera/elevator-make-ABC/elevator-id-3"
  # hilton, de, munich, city
    "apim/elevator-co/data-product/V1/json/elevator/critical-alarm/hilton/de/munich/city/elevator-make-ABC/elevator-id-4"
    "apim/elevator-co/data-product/V1/json/elevator/critical-alarm/hilton/de/munich/city/elevator-make-ABC/elevator-id-5"
    "apim/elevator-co/data-product/V1/json/elevator/critical-alarm/hilton/de/munich/city/elevator-make-ABC/elevator-id-6"
  )

##############################################################################################################################
# Run

echo ">>> Send POST request to Azure Function ..."

for topic in ${topics[@]}; do

  functionParams="path=test&pathCompose=withTime"
  functionUrl="$functionBaseUrl&$functionParams"

  timestamp=$(date -u +%Y-%m-%d-%H:%M:%S-%Z)
  type="car2floor_alignment"
  alarmCode=42
  description="critical issue, misalignment car to floor. stop elevator immediatly"
  payload='
  {
    "header": {
      "topic": "'"$topic"'",
      "timestamp": "'"$timestamp"'"
    },
    "body": {
      "type": "'"$type"'",
      "description": "'"$description"'",
      "code": '$alarmCode',
      "details": {
        "floor": 7,
        "discrepancy_mm": 16
      }
    }
  }
  '

  echo $payload | curl \
  -H "Content-Type: application/json" \
  -X POST \
  $functionUrl \
  -d @- \
  -v

  if [[ $? != 0 ]]; then echo; echo ">>> ERROR: sending POST request to function."; exit 1; fi

done


###
# The End.

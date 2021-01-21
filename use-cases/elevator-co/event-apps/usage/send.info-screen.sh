#!/usr/bin/env bash

scriptDir=$(cd $(dirname "$0") && pwd);
tmpDir="$scriptDir/tmp"
mkdir -p $tmpDir; rm -rf "$tmpDir/*"

echo
echo "Sending info-screen events ..."
echo

# ######################################################################
# uncomment to disable validation against schema
# NO_VALIDATION="True"
# ######################################################################

# solace broker connection details
REST_USERNAME="solace-cloud-client"
REST_PASSWORD="enfe56t36gbp4evn4hner9grmh"
REST_HOST="http://mr1i5g7tif6z9h.messaging.solace.cloud:9000"

eventSchemaFile="$scriptDir/info-screen.schema.json"
payloadFile="$tmpDir/info-screen.payload.json"

# TOPICs
# apim/elevator-co/data-product/V1/json/elevator/info-screen/{resource_org_id}/{resource_region_id}/{resource_sub_region_id}/{resource_site_id}/{resource_type}/{resource_id}
topics=(
# hilton, france, paris, opera
  "apim/elevator-co/data-product/V1/json/elevator/info-screen/hilton/FR/paris/opera/elevator-make-ABC/elevator-id-1"
  "apim/elevator-co/data-product/V1/json/elevator/info-screen/hilton/FR/paris/opera/elevator-make-ABC/elevator-id-2"
  "apim/elevator-co/data-product/V1/json/elevator/info-screen/hilton/FR/paris/opera/elevator-make-ABC/elevator-id-3"
# hilton, de, munich, city
  "apim/elevator-co/data-product/V1/json/elevator/info-screen/hilton/DE/munich/city/elevator-make-ABC/elevator-id-4"
  "apim/elevator-co/data-product/V1/json/elevator/info-screen/hilton/DE/munich/city/elevator-make-ABC/elevator-id-5"
  "apim/elevator-co/data-product/V1/json/elevator/info-screen/hilton/DE/munich/city/elevator-make-ABC/elevator-id-6"
)

##############################################################################################################################
# Run
eventNum=0
for i in {1..1000}; do
    for topic in ${topics[@]}; do
      # echo "press return to send or ctrl-c to abort"
      # read x
      sleep 2
      ((eventNum++))
      timestamp=$(date -u +%Y-%m-%d-%H:%M:%S-%Z)
      num_sessions=$((1 + $RANDOM % 80))
      avg_clicks_per_session=$((1 + $RANDOM % 5))
      payload='
      {
        "header": {
          "topic": "'"$topic"'",
          "timestamp": "'"$timestamp"'"
        },
        "body": {
          "num_sessions_last_hour": '$num_sessions',
          "avg_clicks_per_session": '$avg_clicks_per_session'
        }
      }
      '
      if [[ -z "$NO_VALIDATION" ]]; then
        # payloadJson=$(echo $payload | jq .)
        # echo $payloadJson | jq
        # cat $eventSchemaFile | jq
        echo $payload > $payloadFile
        # echo $payload | jq .
        jsonschema --instance $payloadFile $eventSchemaFile
        code=$?; if [[ $code != 0 ]]; then echo ">>> ERROR - code=$code - jsonschema"; exit 1; fi
      fi
      echo ----------------------------------------------
      echo "event: $eventNum"
      echo "topic: $topic"
      echo "payload: $payload"

      # Solace-Delivery-Mode: [Direct | Non-Persistent | Persistent]
      echo $payload | curl -v \
        -H "Content-Type: application/json" \
        -H "Solace-delivery-mode: direct" \
        -X POST \
        -u $REST_USERNAME:$REST_PASSWORD \
        $REST_HOST/TOPIC/$topic \
        -d @- \
        > /dev/null 2>&1

    done
done

# The End.

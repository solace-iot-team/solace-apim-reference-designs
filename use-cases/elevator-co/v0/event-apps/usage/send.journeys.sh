#!/usr/bin/env bash

scriptDir=$(cd $(dirname "$0") && pwd);
tmpDir="$scriptDir/tmp"
mkdir -p $tmpDir; rm -rf "$tmpDir/*"

echo
echo "Sending journeys ..."
echo

# ######################################################################
# uncomment to disable validation against schema
# NO_VALIDATION="True"
# ######################################################################

# solace broker connection details as env variables
if [ -z "$SOLACE_APIM_REST_USERNAME" ]; then echo ">>> ERROR: missing env var: SOLACE_APIM_REST_USERNAME"; exit 1; fi
if [ -z "$SOLACE_APIM_REST_PASSWORD" ]; then echo ">>> ERROR: missing env var: SOLACE_APIM_REST_PASSWORD"; exit 1; fi
if [ -z "$SOLACE_APIM_REST_URL" ]; then echo ">>> ERROR: missing env var: SOLACE_APIM_REST_URL"; exit 1; fi
REST_USERNAME=$SOLACE_APIM_REST_USERNAME
REST_PASSWORD=$SOLACE_APIM_REST_PASSWORD
REST_HOST=$SOLACE_APIM_REST_URL

eventSchemaFile="$scriptDir/journey.schema.json"
payloadFile="$tmpDir/journey.payload.json"

# TOPICs
# apim/elevator-co/data-product/V1/json/elevator/journey/{resource_org_id}/{resource_region_id}/{resource_sub_region_id}/{resource_site_id}/{resource_type}/{resource_id}
topics=(
# hilton, france, paris, opera
  "apim/elevator-co/data-product/V1/json/elevator/journey/hilton/fr/paris/opera/elev-make1/elevator-id-1"
  "apim/elevator-co/data-product/V1/json/elevator/journey/hilton/fr/paris/opera/elev-make1/elevator-id-2"
  "apim/elevator-co/data-product/V1/json/elevator/journey/hilton/fr/paris/opera/elev-make1/elevator-id-3"
# hilton, de, munich, city
  "apim/elevator-co/data-product/V1/json/elevator/journey/hilton/de/munich/city/elev-make1/elevator-id-4"
  "apim/elevator-co/data-product/V1/json/elevator/journey/hilton/de/munich/city/elev-make1/elevator-id-5"
  "apim/elevator-co/data-product/V1/json/elevator/journey/hilton/de/munich/city/elev-make1/elevator-id-6"
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
      from_floor=$((1 + $RANDOM % 42))
      to_floor=$((1 + $RANDOM % 42))
      if [ $from_floor -eq $to_floor ]; then ((from_floor--)); fi
      if [ $from_floor -lt $to_floor ]; then type="up"; else type="down"; fi
      payload='
      {
        "header": {
          "topic": "'"$topic"'",
          "timestamp": "'"$timestamp"'"
        },
        "body": {
          "type": "'"$type"'",
          "from_floor": '$from_floor',
          "to_floor": '$to_floor'
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

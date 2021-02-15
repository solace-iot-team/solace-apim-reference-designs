#!/usr/bin/env bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  echo "** Trapped CTRL-C"
  if [[ ! -z "$httpServerPid" ]]; then
    echo "stopping http server: $httpServerPid"
    kill $httpServerPid
  fi
  exit 1
}

scriptDir=$(cd $(dirname "$0") && pwd);
tmpDir="$scriptDir/tmp"
mkdir -p $tmpDir; rm -rf "$tmpDir/*"
sampleMsgsDir="$scriptDir/sample-messages"

echo
echo "Sending maintenance events ..."
echo

# ######################################################################
# uncomment to disable recording sample messages
NO_RECORDING_SAMPLE_MESSAGES="True"
# ######################################################################

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

eventSchemaFile="$scriptDir/maintenance.schema.json"
payloadFile="$tmpDir/maintenance.payload.json"

# TOPICs
# 'apim/elevator-co/api/V1/json/{resource_region_id}/{equipment_type}/{event_type}/{resource_type}/{resource_id}':
# apim/elevator-co/data-product/V1/json/elevator/maintenance/{resource_org_id}/{resource_region_id}/{resource_sub_region_id}/{resource_site_id}/{resource_type}/{resource_id}
topics=(
  "apim/elevator-co/api/V1/json/fr/elevator/maintenace/elev-make-1/elevator-id-1"
  "apim/elevator-co/api/V1/json/fr/elevator/maintenace/elev-make-1/elevator-id-2"
  "apim/elevator-co/api/V1/json/fr/elevator/maintenace/elev-make-2/elevator-id-3"
  "apim/elevator-co/api/V1/json/fr/elevator/maintenace/elev-make-2/elevator-id-4"
  "apim/elevator-co/api/V1/json/de/elevator/maintenace/elev-make-1/elevator-id-5"
  "apim/elevator-co/api/V1/json/de/elevator/maintenace/elev-make-1/elevator-id-6"
  "apim/elevator-co/api/V1/json/de/elevator/maintenace/elev-make-2/elevator-id-7"
  "apim/elevator-co/api/V1/json/de/elevator/maintenace/elev-make-2/elevator-id-8"
)

##############################################################################################################################
# start schema http server
if [[ -z "$NO_VALIDATION" ]]; then
  nohup python3 -m http.server 8811 > $tmpDir/schema.http.server.out 2>&1 &
  httpServerPid="$!"
  echo "started schema http server on 8811, pid=$httpServerPid"
fi

##############################################################################################################################
# Run
eventNum=0
for i in {1..2}; do
    for topic in ${topics[@]}; do
      # echo "press return to send or ctrl-c to abort"
      # read x
      sleep 2
      ((eventNum++))
      timestamp=$(date -u +%Y-%m-%d-%H:%M:%S-%Z)
      component_id="ABC-"$((1 + $RANDOM % 10000))
      timewindow_days=$((5 + $RANDOM % 20))
      uuid=$(python3 -c "import uuid; print(uuid.uuid4())")
      payload='
      {
        "header": {
          "topic": "'"$topic"'",
          "timestamp": "'"$timestamp"'",
          "tracking_id": "'"$uuid"'"
        },
        "body": {
          "component_id": "'"$component_id"'",
          "description": "misalignment car to floor",
          "timewindow_days": '$timewindow_days',
          "probability_of_failure_pct": 90,
          "details": {
            "reasons": [
              "misalignment car to floor > 8mm",
              "avg journeys / day > 25"
            ]
          }
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

      if [[ -z "$NO_RECORDING_SAMPLE_MESSAGES" ]]; then
        sampleMsgFileName="maintenance.payload.sample.$eventNum"
        echo $payload | jq . > "$sampleMsgsDir/$sampleMsgFileName.json"
        # echo $payload | yq -y . > "$sampleMsgsDir/$sampleMsgFileName.yml"
      fi

    done
done


##############################################################################################################################
# stop local web server for schemas
if [[ -z "$NO_VALIDATION" ]]; then
  kill $httpServerPid
fi

# The End.

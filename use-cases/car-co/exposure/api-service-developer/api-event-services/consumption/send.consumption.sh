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
echo "Sending consumption events ..."
echo

# ######################################################################
# uncomment to disable recording sample messages
NO_RECORDING_SAMPLE_MESSAGES="True"
# ######################################################################

# ######################################################################
# uncomment to disable validation against schema
NO_VALIDATION="True"
# ######################################################################

# solace broker connection details as env variables
if [ -z "$APIM_DEV_GW_REST_USERNAME" ]; then echo ">>> ERROR: missing env var: APIM_DEV_GW_REST_USERNAME"; exit 1; fi
if [ -z "$APIM_DEV_GW_REST_PASSWORD" ]; then echo ">>> ERROR: missing env var: APIM_DEV_GW_REST_PASSWORD"; exit 1; fi
if [ -z "$APIM_DEV_GW_REST_URL" ]; then echo ">>> ERROR: missing env var: APIM_DEV_GW_REST_URL"; exit 1; fi
REST_USERNAME=$APIM_DEV_GW_REST_USERNAME
REST_PASSWORD=$APIM_DEV_GW_REST_PASSWORD
REST_HOST=$APIM_DEV_GW_REST_URL

eventSchemaFile="$scriptDir/consumption.schema.json"
payloadFile="$tmpDir/consumption.payload.json"

# TOPICs
# `apim/car-co/api/V1/json/{region_id}/{make}/{model}/{vin}/{event_type}`
topics=(
  "apim/car-co/api/V1/json/fr/108/M2018/vin-0/consumption"
  "apim/car-co/api/V1/json/fr/2008/MTPA/vin-1/consumption"
  "apim/car-co/api/V1/json/fr/108/M2018/vin-2/consumption"
  "apim/car-co/api/V1/json/fr/2008/MTPA/vin-3/consumption"
  "apim/car-co/api/V1/json/de/108/M2018/vin-4/consumption"
  "apim/car-co/api/V1/json/de/2008/MTPA/vin-5/consumption"
  "apim/car-co/api/V1/json/de/108/M2018/vin-6/consumption"
  "apim/car-co/api/V1/json/it/2008/MTPA/vin-7/consumption"
  "apim/car-co/api/V1/json/it/108/M2018/vin-8/consumption"
  "apim/car-co/api/V1/json/it/2008/MTPA/vin-9/consumption"
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
for i in {1..2000}; do
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
          "timestamp": "'"$timestamp"'"
        },
        "body": {
          "fuel": 10,
          "tyre": 1.8,
          "battery": 2.4,
          "oil": 90
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
        sampleMsgFileName="consumption.payload.sample.$eventNum"
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

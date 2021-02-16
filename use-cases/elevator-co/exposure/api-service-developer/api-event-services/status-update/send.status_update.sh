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
echo "Sending status_update events ..."
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

eventSchemaFile="$scriptDir/status_update.schema.json"
payloadFile="$tmpDir/status_update.payload.json"

# TOPICs
# apim/elevator-co/api/V1/json/status/{tracking_id}
topics=(
  "apim/elevator-co/api/V1/json/status"
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
for i in {1..10}; do
    for _topic in ${topics[@]}; do
      # echo "press return to send or ctrl-c to abort"
      # read x
      sleep 2
      ((eventNum++))
      timestamp=$(date -u +%Y-%m-%d-%H:%M:%S-%Z)
      # tracking_id="TR_ID-"$((1 + $RANDOM % 10000))
      tracking_id=$(python3 -c "import uuid; print(uuid.uuid4())")
      topic="$_topic/$tracking_id"
      if (( $eventNum % 2 )); then
        status="received"
      else
        status="resolved"
      fi
      payload='
      {
        "status_update": {
          "timestamp": "'"$timestamp"'",
          "status": "'"$status"'",
          "tracking_id": "'"$tracking_id"'"
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
        sampleMsgFileName="status_update.payload.sample.$eventNum"
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

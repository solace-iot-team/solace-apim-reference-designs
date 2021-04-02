#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));


############################################################################################################################
# Environment Variables

  if [ -z "$APIM_BOOTSTRAP_USE_CASE_NAME" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_USE_CASE_NAME"; exit 1; fi
  if [ -z "$APIM_BOOTSTRAP_MONGO_PORT" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_MONGO_PORT"; exit 1; fi
  if [ -z "$APIM_BOOTSTRAP_PLATFORM_API_SERVER_PORT" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_PLATFORM_API_SERVER_PORT"; exit 1; fi
  if [ -z "$APIM_BOOTSTRAP_PLATFORM_API_SERVER_LOG_LEVEL" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_PLATFORM_API_SERVER_LOG_LEVEL"; exit 1; fi

############################################################################################################################
# Run

echo ">>> Bootstrap Local Mongo DB ..."
  export APIM_SYSTEM_USE_CASE_NAME=$APIM_BOOTSTRAP_USE_CASE_NAME
  export APIM_SYSTEM_MONGO_PORT=$APIM_BOOTSTRAP_MONGO_PORT
  runScript="$scriptDir/apim-system/local/mongodb/start.mongo.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo " >>> ERROR - code=$code - runScript='$runScript' - $scriptName"; exit 1; fi
echo ">>> Success";

echo ">>> Bootstrap Local Platform API Server ..."
  export APIM_SYSTEM_USE_CASE_NAME=$APIM_BOOTSTRAP_USE_CASE_NAME
  export APIM_SYSTEM_MONGO_PORT=$APIM_BOOTSTRAP_MONGO_PORT
  export APIM_SYSTEM_PLATFORM_API_SERVER_DATA_VOLUME_MOUNT="$scriptDir/platform-api-server-data"
  export APIM_SYSTEM_PLATFORM_API_SERVER_FILE_USER_REGISTRY="organization_users.json"
  export APIM_SYSTEM_PLATFORM_API_SERVER_PORT=$APIM_BOOTSTRAP_PLATFORM_API_SERVER_PORT
  export APIM_SYSTEM_PLATFORM_API_SERVER_LOG_LEVEL=$APIM_BOOTSTRAP_PLATFORM_API_SERVER_LOG_LEVEL

  runScript="$scriptDir/apim-system/local/server/start.server.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo " >>> ERROR - code=$code - runScript='$runScript' - $scriptName"; exit 1; fi
echo ">>> Success";

###
# The End.

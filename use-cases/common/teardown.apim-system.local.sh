#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Environment Variables

  if [ -z "$APIM_BOOTSTRAP_USE_CASE_NAME" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_USE_CASE_NAME"; exit 1; fi
  if [ -z "$APIM_BOOTSTRAP_CONNECTOR_SERVER_PORT" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_CONNECTOR_SERVER_PORT"; exit 1; fi
  if [ -z "$APIM_BOOTSTRAP_DEMO_PORTAL_SERVER_PORT" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_DEMO_PORTAL_SERVER_PORT"; exit 1; fi

############################################################################################################################
# Run

echo ">>> Teardown Local System for $APIM_BOOTSTRAP_USE_CASE_NAME ..."

  export APIM_SYSTEM_PROJECT_NAME=$APIM_BOOTSTRAP_USE_CASE_NAME
  export APIM_SYSTEM_CONNECTOR_SERVER_PORT=$APIM_BOOTSTRAP_CONNECTOR_SERVER_PORT
  export APIM_SYSTEM_DEMO_PORTAL_SERVER_PORT=$APIM_BOOTSTRAP_DEMO_PORTAL_SERVER_PORT

  runScript="$scriptDir/apim-system/local/stop.system.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo " >>> ERROR - code=$code - runScript='$runScript' - $scriptName"; exit 1; fi

echo ">>> Success";

###
# The End.

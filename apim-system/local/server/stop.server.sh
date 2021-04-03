#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Environment Variables

  if [ -z "$APIM_SYSTEM_USE_CASE_NAME" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_USE_CASE_NAME"; exit 1; fi

############################################################################################################################
# Run

echo " >>> Removing docker container ..."
  containerName=$APIM_SYSTEM_USE_CASE_NAME-platform-api-server
  runScript="docker rm -f $containerName"
  $runScript
  if [[ $? != 0 ]]; then echo " >>> ERROR: $runScript "; exit 1; fi
  docker ps -a
echo " >>> Success."

###
# The End.

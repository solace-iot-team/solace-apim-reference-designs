#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Environment Variables

  if [ -z "$APIM_BOOTSTRAP_USE_CASE_NAME" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_USE_CASE_NAME"; exit 1; fi

############################################################################################################################
# Run

  echo " >>> Getting server logs ..."
    containerName=$APIM_BOOTSTRAP_USE_CASE_NAME-apim-connector
    runScript="docker logs $containerName"
    $runScript
    if [[ $? != 0 ]]; then echo " >>> ERROR: $runScript "; exit 1; fi
  echo " >>> Success."

###
# The End.

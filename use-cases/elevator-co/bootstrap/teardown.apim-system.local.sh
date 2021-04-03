#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));


############################################################################################################################
# Run

echo ">>> Teardown Local Platform API Server ..."
  export APIM_SYSTEM_USE_CASE_NAME=$APIM_BOOTSTRAP_USE_CASE_NAME
  runScript="./apim-system/local/server/stop.server.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo " >>> ERROR - code=$code - runScript='$runScript' - $scriptName"; exit 1; fi
echo ">>> Success";

echo ">>> Teardown Local Mongo DB ..."
  export APIM_SYSTEM_USE_CASE_NAME=$APIM_BOOTSTRAP_USE_CASE_NAME
  export APIM_SYSTEM_MONGO_PORT=$APIM_BOOTSTRAP_MONGO_PORT
  runScript="./apim-system/local/mongodb/stop.mongo.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo " >>> ERROR - code=$code - runScript='$runScript' - $scriptName"; exit 1; fi
echo ">>> Success";

###
# The End.

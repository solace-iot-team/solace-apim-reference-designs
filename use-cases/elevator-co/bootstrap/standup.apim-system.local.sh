#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Environment Variables

  if [ -z "$APIM_BOOTSTRAP_USE_CASE_NAME" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_USE_CASE_NAME"; exit 1; fi
  if [ ! -d "$APIM_SYSTEM_PLATFORM_API_SERVER_DATA_VOLUME_MOUNT" ]; then echo ">>> ERROR: - $scriptName - env var APIM_SYSTEM_PLATFORM_API_SERVER_DATA_VOLUME_MOUNT, directory does not exist: '$APIM_SYSTEM_PLATFORM_API_SERVER_DATA_VOLUME_MOUNT'"; exit 1; fi
  fileUserRegistry="$APIM_SYSTEM_PLATFORM_API_SERVER_DATA_VOLUME_MOUNT/$APIM_SYSTEM_PLATFORM_API_SERVER_FILE_USER_REGISTRY"
  if [ ! -f "$fileUserRegistry" ]; then echo ">>> ERROR: - $scriptName - env var APIM_SYSTEM_PLATFORM_API_SERVER_FILE_USER_REGISTRY, file does not exist: '$fileUserRegistry'"; exit 1; fi


############################################################################################################################
# Run

echo ">>> Standup Local System for $APIM_BOOTSTRAP_USE_CASE_NAME ..."

  runScript="$scriptDir/apim-system/local/start.system.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo " >>> ERROR - code=$code - runScript='$runScript' - $scriptName"; exit 1; fi

echo ">>> Success";

###
# The End.

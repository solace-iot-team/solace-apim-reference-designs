#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Environment Variables

  if [ -z "$APIM_BOOTSTRAP_USE_CASE_NAME" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_USE_CASE_NAME"; exit 1; fi

############################################################################################################################
# Run

echo ">>> Standup Local System for $APIM_BOOTSTRAP_USE_CASE_NAME ..."

  export APIM_SYSTEM_PROJECT_NAME=$APIM_BOOTSTRAP_USE_CASE_NAME
  export APIM_SYSTEM_PLATFORM_API_SERVER_DATA_VOLUME_MOUNT="$scriptDir/platform-api-server-data"
  export APIM_SYSTEM_PLATFORM_API_SERVER_FILE_USER_REGISTRY="organization_users.json"
  export APIM_SYSTEM_PLATFORM_API_SERVER_ORG_API_USER=$APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_API_USER
  export APIM_SYSTEM_PLATFORM_API_SERVER_ORG_API_USER_PWD=$APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_API_USER_PWD
  export APIM_SYSTEM_PLATFORM_API_SERVER_ADMIN_USER=$APIM_BOOTSTRAP_PLATFORM_API_SERVER_ADMIN_USER
  export APIM_SYSTEM_PLATFORM_API_SERVER_ADMIN_USER_PWD=$APIM_BOOTSTRAP_PLATFORM_API_SERVER_ADMIN_USER_PWD
  export APIM_SYSTEM_PLATFORM_API_SERVER_PORT=$APIM_BOOTSTRAP_PLATFORM_API_SERVER_PORT

  runScript="$scriptDir/apim-system/local/start.system.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo " >>> ERROR - code=$code - runScript='$runScript' - $scriptName"; exit 1; fi

echo ">>> Success";

###
# The End.

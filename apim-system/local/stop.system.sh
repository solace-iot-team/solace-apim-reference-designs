#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Environment Variables

  if [ -z "$APIM_SYSTEM_PROJECT_NAME" ]; then export APIM_SYSTEM_PROJECT_NAME="apim-system"; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_PORT" ]; then export APIM_SYSTEM_CONNECTOR_SERVER_PORT=9090; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_DOCKER_IMAGE" ]; then
    export APIM_SYSTEM_CONNECTOR_SERVER_DOCKER_IMAGE="solaceiotteam/platform-api-server:latest";
  fi
  if [ -z "$APIM_SYSTEM_DEMO_PORTAL_SERVER_PORT" ]; then export APIM_SYSTEM_DEMO_PORTAL_SERVER_PORT=9091; fi
  if [ -z "$APIM_SYSTEM_DEMO_PORTAL_SERVER_DOCKER_IMAGE" ]; then
    export APIM_SYSTEM_DEMO_PORTAL_SERVER_DOCKER_IMAGE="solaceiotteam/apim-demo-portal:latest";
  fi


############################################################################################################################
# Run

echo " >>> Docker-compose down for project: $APIM_SYSTEM_PROJECT_NAME ..."

  export DEMO_PORTAL_SERVER_PORT=$APIM_SYSTEM_DEMO_PORTAL_SERVER_PORT
  dockerComposeFile="$scriptDir/docker-compose.yml"
  docker-compose -p $APIM_SYSTEM_PROJECT_NAME -f "$dockerComposeFile" down --volumes --rmi all
  if [[ $? != 0 ]]; then echo " >>> ERROR: docker compose down for '$APIM_SYSTEM_PROJECT_NAME'"; exit 1; fi
  docker ps -a

echo " >>> Success."

###
# The End.

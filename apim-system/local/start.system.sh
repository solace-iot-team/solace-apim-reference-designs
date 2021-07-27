#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Environment Variables
  # general
  if [ -z "$APIM_SYSTEM_PROJECT_NAME" ]; then export APIM_SYSTEM_PROJECT_NAME="apim-reference"; fi
  # apim connector
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_DATA_VOLUME_MOUNT" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_CONNECTOR_SERVER_DATA_VOLUME_MOUNT"; exit 1; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_FILE_USER_REGISTRY" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_CONNECTOR_SERVER_FILE_USER_REGISTRY"; exit 1; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_PORT" ]; then export APIM_SYSTEM_CONNECTOR_SERVER_PORT=9090; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_DOCKER_IMAGE" ]; then
    export APIM_SYSTEM_CONNECTOR_SERVER_DOCKER_IMAGE="solaceiotteam/apim-connector-server:latest";
  fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_LOG_LEVEL" ]; then export APIM_SYSTEM_CONNECTOR_SERVER_LOG_LEVEL=debug; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_EXTRACTION_USER_PRINCIPAL" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_CONNECTOR_SERVER_AUTH_EXTRACTION_USER_PRINCIPAL"; exit 1; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_EXTRACTION_ORGS" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_CONNECTOR_SERVER_AUTH_EXTRACTION_ORGS"; exit 1; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_EXTRACTION_ROLES" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_CONNECTOR_SERVER_AUTH_EXTRACTION_ROLES"; exit 1; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_VERIFICATION_KEY" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_CONNECTOR_SERVER_AUTH_VERIFICATION_KEY"; exit 1; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_VERIFICATION_ISSUER" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_CONNECTOR_SERVER_AUTH_VERIFICATION_ISSUER"; exit 1; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_VERIFICATION_AUD" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_CONNECTOR_SERVER_AUTH_VERIFICATION_AUD"; exit 1; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_DISCOVERY_OIDC_URL" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_CONNECTOR_SERVER_AUTH_DISCOVERY_OIDC_URL"; exit 1; fi
  if [ -z "$APIM_SYSTEM_CONNECTOR_EVENT_PORTAL_APIS_PROXY_MODE" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_CONNECTOR_EVENT_PORTAL_APIS_PROXY_MODE"; exit 1; fi
  # demo portal
  if [ -z "$APIM_SYSTEM_DEMO_PORTAL_ORG_API_USER" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_DEMO_PORTAL_ORG_API_USER"; exit 1; fi
  if [ -z "$APIM_SYSTEM_DEMO_PORTAL_ORG_API_USER_PWD" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_DEMO_PORTAL_ORG_API_USER_PWD"; exit 1; fi
  if [ -z "$APIM_SYSTEM_DEMO_PORTAL_ADMIN_USER" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_DEMO_PORTAL_ADMIN_USER"; exit 1; fi
  if [ -z "$APIM_SYSTEM_DEMO_PORTAL_ADMIN_USER_PWD" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_DEMO_PORTAL_ADMIN_USER_PWD"; exit 1; fi
  if [ -z "$APIM_SYSTEM_DEMO_PORTAL_SERVER_PORT" ]; then export APIM_SYSTEM_DEMO_PORTAL_SERVER_PORT=9091; fi
  if [ -z "$APIM_SYSTEM_DEMO_PORTAL_SERVER_DOCKER_IMAGE" ]; then
    export APIM_SYSTEM_DEMO_PORTAL_SERVER_DOCKER_IMAGE="solaceiotteam/apim-demo-portal:latest";
  fi

############################################################################################################################
# Settings

  dockerComposeFile="$scriptDir/docker-compose.yml"
  platformApiServerDataVolumeMountPath="$APIM_SYSTEM_CONNECTOR_SERVER_DATA_VOLUME_MOUNT"
  if [ ! -d "$platformApiServerDataVolumeMountPath" ]; then echo ">>> ERROR: - $scriptName - data volume not found: $platformApiServerDataVolumeMountPath"; exit 1; fi
  externalFileUserRegistry="$platformApiServerDataVolumeMountPath/$APIM_SYSTEM_CONNECTOR_SERVER_FILE_USER_REGISTRY"
  if [ ! -f "$externalFileUserRegistry" ]; then echo ">>> ERROR: - $scriptName - user file not found: $externalFileUserRegistry"; exit 1; fi
  platformApiServerDataVolumeInternal="/platform-api-server/data"
  fileUserRegistry="$platformApiServerDataVolumeInternal/$APIM_SYSTEM_CONNECTOR_SERVER_FILE_USER_REGISTRY"
  jwtKey="$platformApiServerDataVolumeInternal/$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_VERIFICATION_KEY"

  export PLATFORM_DATA_MOUNT_PATH=$platformApiServerDataVolumeMountPath
  export PLATFORM_DATA_INTERNAL_PATH=$platformApiServerDataVolumeInternal
  export LOG_LEVEL=$APIM_SYSTEM_CONNECTOR_SERVER_LOG_LEVEL
  export APP_ID=$APIM_SYSTEM_PROJECT_NAME
  export FILE_USER_REGISTRY=$fileUserRegistry
  # export ADMIN_USER=$APIM_SYSTEM_CONNECTOR_SERVER_ADMIN_USER
  # export ADMIN_PASSWORD=$APIM_SYSTEM_CONNECTOR_SERVER_ADMIN_USER_PWD
  export AUTH_EXTRACTION_USER_PRINCIPAL=$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_EXTRACTION_USER_PRINCIPAL
  export AUTH_EXTRACTION_ORGS=$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_EXTRACTION_ORGS
  export AUTH_EXTRACTION_ROLES=$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_EXTRACTION_ROLES
  export AUTH_VERIFICATION_KEY=$jwtKey
  export AUTH_VERIFICATION_ISSUER=$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_VERIFICATION_ISSUER
  export AUTH_VERIFICATION_AUD=$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_VERIFICATION_AUD
  export AUTH_DISCOVERY_OIDC_URL=$APIM_SYSTEM_CONNECTOR_SERVER_AUTH_DISCOVERY_OIDC_URL
  export APIS_PROXY_MODE=$APIM_SYSTEM_CONNECTOR_EVENT_PORTAL_APIS_PROXY_MODE

  export DEMO_PORTAL_API_USER=$APIM_SYSTEM_DEMO_PORTAL_ORG_API_USER
  export DEMO_PORTAL_API_USER_PWD=$APIM_SYSTEM_DEMO_PORTAL_ORG_API_USER_PWD
  export DEMO_PORTAL_ADMIN_USER=$APIM_SYSTEM_DEMO_PORTAL_ADMIN_USER
  export DEMO_PORTAL_ADMIN_USER_PWD=$APIM_SYSTEM_DEMO_PORTAL_ADMIN_USER_PWD
  export DEMO_PORTAL_SERVER_PORT=$APIM_SYSTEM_DEMO_PORTAL_SERVER_PORT

  export DOCKER_CLIENT_TIMEOUT=120
  export COMPOSE_HTTP_TIMEOUT=120

############################################################################################################################
# Run

echo " >>> Docker-compose down for project: $APIM_SYSTEM_PROJECT_NAME ..."
  docker-compose -p $APIM_SYSTEM_PROJECT_NAME -f "$dockerComposeFile" down --volumes
  if [[ $? != 0 ]]; then echo " >>> ERROR: docker compose up for '$APIM_SYSTEM_PROJECT_NAME'"; exit 1; fi
echo " >>> Success."

echo " >>> Docker-compose up for project: $APIM_SYSTEM_PROJECT_NAME ..."

  docker-compose -p $APIM_SYSTEM_PROJECT_NAME -f "$dockerComposeFile" up -d
  if [[ $? != 0 ]]; then echo " >>> ERROR: docker compose up for '$APIM_SYSTEM_PROJECT_NAME'"; exit 1; fi

  docker ps -a

  containerName="$APIM_SYSTEM_PROJECT_NAME-apim-connector"
  echo "   >>> check docker logs for '$containerName' ..."
    WORKING_DIR=$scriptDir/tmp; mkdir -p $WORKING_DIR; rm -rf $WORKING_DIR/*;
    dockerLogsFile="$WORKING_DIR/$containerName.docker.logs"
    isInitialized=0; checks=0
    until [[ $isInitialized -gt 2 || $checks -gt 10 ]]; do
      ((checks++))
      echo "   check: $checks"
      docker logs $containerName > $dockerLogsFile
      if [[ $? != 0 ]]; then echo " >>> ERROR: docker logs '$containerName'"; exit 1; fi
      entryListeningOnPort=$(grep -n -e "Listening on port $PLATFORM_PORT" $dockerLogsFile)
      echo "      - entryListeningOnPort='$entryListeningOnPort'"
      if [ ! -z "$entryListeningOnPort" ]; then ((isInitialized++)); fi
      entryConnected2Mongo=$(grep -n -e "Connected to Mongo" $dockerLogsFile)
      echo "      - entryConnected2Mongo='$entryConnected2Mongo'"
      if [ ! -z "$entryConnected2Mongo" ]; then ((isInitialized++)); fi
      entryLoadedUserRegistry=$(grep -n -e "Loaded user registry" $dockerLogsFile)
      echo "      - entryLoadedUserRegistry='$entryLoadedUserRegistry'"
      if [ ! -z "$entryLoadedUserRegistry" ]; then ((isInitialized++)); fi
      if [ $isInitialized -lt 3 ]; then sleep 2s; fi
    done
    if [ $isInitialized -lt 3 ]; then echo " >>> ERROR: server is not initialized, checks=$checks"; exit 1; fi
  echo "   >>> success."

echo " >>> Success."

###
# The End.

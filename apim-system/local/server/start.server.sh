#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Environment Variables

  if [ -z "$APIM_SYSTEM_USE_CASE_NAME" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_USE_CASE_NAME"; exit 1; fi
  if [ -z "$APIM_SYSTEM_MONGO_PORT" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_MONGO_PORT"; exit 1; fi
  if [ -z "$APIM_SYSTEM_PLATFORM_API_SERVER_DATA_VOLUME_MOUNT" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_PLATFORM_API_SERVER_DATA_VOLUME_MOUNT"; exit 1; fi
  if [ -z "$APIM_SYSTEM_PLATFORM_API_SERVER_FILE_USER_REGISTRY" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_PLATFORM_API_SERVER_FILE_USER_REGISTRY"; exit 1; fi
  if [ -z "$APIM_SYSTEM_PLATFORM_API_SERVER_PORT" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_PLATFORM_API_SERVER_PORT"; exit 1; fi
  if [ -z "$APIM_SYSTEM_PLATFORM_API_SERVER_LOG_LEVEL" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_SYSTEM_PLATFORM_API_SERVER_LOG_LEVEL"; exit 1; fi

############################################################################################################################
# Run

env | grep APIM_SYSTEM


dockerComposeFileMac="$scriptDir/docker-compose.mac.yml"
localMongoDBUrlMac="mongodb://host.docker.internal:$APIM_SYSTEM_MONGO_PORT/platform?retryWrites=true&w=majority"
dockerComposeFileLinux="$scriptDir/docker-compose.linux.yml"
localMongoDBUrlLinux="mongodb://127.0.0.1:$APIM_SYSTEM_MONGO_PORT/platform?retryWrites=true&w=majority"
dockerComposeFile="null"
localMongoDBUrl="null"
platformApiServerDataVolumeMountPath="$APIM_SYSTEM_PLATFORM_API_SERVER_DATA_VOLUME_MOUNT"
externalFileUserRegistry="$platformApiServerDataVolumeMountPath/$APIM_SYSTEM_PLATFORM_API_SERVER_FILE_USER_REGISTRY"
if [ ! -f "$externalFileUserRegistry" ]; then echo ">>> ERROR: - $scriptName - user file not found: $externalFileUserRegistry"; exit 1; fi
platformApiServerDataVolumeInternal="/platform-api-server/data"
fileUserRegistry="$platformApiServerDataVolumeInternal/$APIM_SYSTEM_PLATFORM_API_SERVER_FILE_USER_REGISTRY"

echo " >>> Starting Platform API Server in docker for $APIM_SYSTEM_USE_CASE_NAME ..."

echo "hello world"
echo "hello world"
echo "hello world"
echo "hello world"
echo "hello world"
echo "hello world"
echo "hello world"


  uName=$(uname -s)
  case $uName in
    Darwin)
      dockerComposeFile=$dockerComposeFileMac
      localMongoDBUrl=$localMongoDBUrlMac
      ;;
    Linux)
      echo "starting docker with linux compose"
      dockerComposeFile=$dockerComposeFileLinux
      localMongoDBUrl=$localMongoDBUrlLinux
      ;;
    *)
      echo ">>> ERROR: unknown OS: $uName"; exit 1
      ;;
  esac

  export CONTAINER_NAME=$APIM_SYSTEM_USE_CASE_NAME-platform-api-server
  export IMAGE="solaceiotteam/platform-api-server:latest"
  export PLATFORM_DATA_MOUNT_PATH=$platformApiServerDataVolumeMountPath
  export PLATFORM_DATA_INTERNAL_PATH=$platformApiServerDataVolumeInternal
  export PLATFORM_PORT=$APIM_SYSTEM_PLATFORM_API_SERVER_PORT
  export DB_URL=$localMongoDBUrl
  export LOG_LEVEL=$APIM_SYSTEM_PLATFORM_API_SERVER_LOG_LEVEL
  export APP_ID=$APIM_SYSTEM_USE_CASE_NAME
  export FILE_USER_REGISTRY=$fileUserRegistry

  env | grep PLATFORM

  docker-compose -f "$dockerComposeFile" up -d
  if [[ $? != 0 ]]; then echo " >>> ERROR: docker compose with '$dockerComposeFile'"; exit 1; fi
  docker ps -a
echo " >>> Success."

###
# The End.


# Usage:
# cp template.source.env.sh source.env.sh
# vi source.env.sh
# <enter values>
# source source.env.sh

export APIM_SYSTEM_USE_CASE_NAME="{use-case-name}"
export APIM_SYSTEM_MONGO_PORT=27017
export APIM_SYSTEM_PLATFORM_API_SERVER_DATA_VOLUME_MOUNT="{local path to data volume mounted into the container}"
export APIM_SYSTEM_PLATFORM_API_SERVER_FILE_USER_REGISTRY="{file name of the org users json, must exist in mount path}"
export APIM_SYSTEM_PLATFORM_API_SERVER_PORT=9090
# debug, info, error
export APIM_SYSTEM_PLATFORM_API_SERVER_LOG_LEVEL=debug

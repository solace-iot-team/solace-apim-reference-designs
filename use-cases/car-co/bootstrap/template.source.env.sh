
# Usage:
# cp template.source.env.sh source.env.sh
# vi source.env.sh
# <enter values>
# source source.env.sh

scriptDir=$(pwd)

# USE CASE SPECIFIC BOOTSTRAP ENVIRONMENT
export APIM_BOOTSTRAP_USE_CASE_NAME="uc-car-co"
export APIM_BOOTSTRAP_ORG_NAME="car-co"
export APIM_BOOTSTRAP_ORG_API_USER="car_co_admin"
export APIM_BOOTSTRAP_ORG_API_USER_PWD="car_co_admin_123!"
export APIM_BOOTSTRAP_ADMIN_USER="admin"
export APIM_BOOTSTRAP_ADMIN_USER_PWD="p3zvZFF7ka4Wrj4p"
export APIM_BOOTSTRAP_SOLACE_CLOUD_API_URL="https://api.solace.cloud/api/v0"
export APIM_BOOTSTRAP_SOLACE_CLOUD_TOKEN="{solace-cloud-token}"
export APIM_BOOTSTRAP_SOLACE_EVENT_PORTAL_API_URL="{event-portal-url}"
export APIM_BOOTSTRAP_SOLACE_EVENT_PORTAL_TOKEN="{solace-event-portal-token}"
export APIM_BOOTSTRAP_SOLACE_CLOUD_DEV_GW_SERVICE_ID="{solace-cloud-dev-gateway-service-id}"
export APIM_BOOTSTRAP_SOLACE_CLOUD_PROD_GW_SERVICE_ID="{solace-cloud-prod-gateway-service-id}"

# Connector Server
export APIM_BOOTSTRAP_CONNECTOR_SERVER_PROTOCOL="http"
export APIM_BOOTSTRAP_CONNECTOR_SERVER_HOST="localhost"
export APIM_BOOTSTRAP_CONNECTOR_SERVER_PORT=9090
export APIM_BOOTSTRAP_CONNECTOR_SERVER_DATA_VOLUME_MOUNT="$scriptDir/apim-connector-data"
export APIM_BOOTSTRAP_CONNECTOR_SERVER_FILE_USER_REGISTRY="organization_users.json"
export APIM_BOOTSTRAP_CONNECTOR_SERVER_DOCKER_IMAGE="solaceiotteam/apim-connector-server:latest"

# Demo Portal
export APIM_BOOTSTRAP_DEMO_PORTAL_SERVER_PORT=9091
export APIM_BOOTSTRAP_DEMO_PORTAL_SERVER_DOCKER_IMAGE="solaceiotteam/apim-demo-portal:latest"

env | grep APIM_BOOTSTRAP

source $scriptDir/../../common/source.env.mapping.sh

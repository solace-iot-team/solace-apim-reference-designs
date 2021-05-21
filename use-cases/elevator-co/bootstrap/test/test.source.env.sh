#
# environment for local testing of bootstrap

scriptDir=$(pwd)

# USE CASE SPECIFIC BOOTSTRAP ENVIRONMENT
export APIM_BOOTSTRAP_USE_CASE_NAME="uc-elevator-co"
export APIM_BOOTSTRAP_ORG_NAME="elevator-co"
export APIM_BOOTSTRAP_ORG_API_USER="elevator_co_admin"
export APIM_BOOTSTRAP_ORG_API_USER_PWD="elevator_co_admin_123!"
export APIM_BOOTSTRAP_ADMIN_USER="admin"
export APIM_BOOTSTRAP_ADMIN_USER_PWD="p3zvZFF7ka4Wrj4p"
# Connector Server
export APIM_BOOTSTRAP_CONNECTOR_SERVER_PROTOCOL="http"
export APIM_BOOTSTRAP_CONNECTOR_SERVER_HOST="localhost"
export APIM_BOOTSTRAP_CONNECTOR_SERVER_PORT=9090
export APIM_BOOTSTRAP_CONNECTOR_SERVER_DATA_VOLUME_MOUNT="$scriptDir/../apim-connector-data"
export APIM_BOOTSTRAP_CONNECTOR_SERVER_FILE_USER_REGISTRY="organization_users.json"
export APIM_BOOTSTRAP_CONNECTOR_SERVER_DOCKER_IMAGE="solaceiotteam/apim-connector-server:latest"

# Demo Portal
export APIM_BOOTSTRAP_DEMO_PORTAL_USER="portal_user"
export APIM_BOOTSTRAP_DEMO_PORTAL_USER_PWD="portal_user_123!"
export APIM_BOOTSTRAP_DEMO_PORTAL_SERVER_PORT=9091
# export APIM_BOOTSTRAP_DEMO_PORTAL_SERVER_DOCKER_IMAGE="solaceiotteam/apim-demo-portal:latest"
export APIM_BOOTSTRAP_DEMO_PORTAL_SERVER_DOCKER_IMAGE="solaceiotteam/apim-demo-portal:0.1.14"

env | grep APIM_BOOTSTRAP

source $scriptDir/../../../common/source.env.mapping.sh

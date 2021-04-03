
# Usage:
# cp template.source.env.sh source.env.sh
# vi source.env.sh
# <enter values>
# source source.env.sh

# general
export APIM_BOOTSTRAP_USE_CASE_NAME="uc-elevator-co"
# apim-system: mongodb
export APIM_BOOTSTRAP_MONGO_PORT=27017
# apim-system: platform-api-server
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_PORT=9090
# 'fatal', 'error', 'warn', 'info', 'debug', 'trace' or 'silent'
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_LOG_LEVEL=debug
# use case
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_PROTOCOL="http"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_HOST="localhost"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_NAME="elevator-co"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_API_USER="elevator-co-admin"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_API_USER_PWD="{password}"
# use case secrets
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_ADMIN_USER="{admin-user}"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_ADMIN_USER_PWD="{admin-password}"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_CLOUD_API_URL="https://api.solace.cloud/api/v0"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_CLOUD_TOKEN="{solace-cloud-token}"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_EVENT_PORTAL_API_URL="https://api.solace.cloud/api/v0"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_EVENT_PORTAL_TOKEN="{solace-event-portal-token}"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_CLOUD_DEV_GW_SERVICE_ID="{solace-cloud-dev-gateway-service-id}"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_CLOUD_PROD_GW_SERVICE_ID="{solace-cloud-prod-gateway-service-id}"

env | grep APIM_BOOTSTRAP

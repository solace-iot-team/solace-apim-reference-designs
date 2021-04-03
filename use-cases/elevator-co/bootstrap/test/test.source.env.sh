#
# environment for local testing of bootstrap

# general
export APIM_BOOTSTRAP_USE_CASE_NAME="uc-elevator-co"
# apim-system: mongodb
export APIM_BOOTSTRAP_MONGO_PORT=27017
# apim-system: platform-api-server
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_PORT=9090
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_LOG_LEVEL=debug
# use case
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_PROTOCOL="http"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_HOST="localhost"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_NAME="elevator-co"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_API_USER="elevator-co-admin"
export APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_API_USER_PWD="elevator-co-123!"

env | grep APIM_BOOTSTRAP

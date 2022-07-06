
#!/bin/bash

# #################################################
# # Solace Management MQTT Broker Configuration
# #
# export SOLACE_MGMT_MQTT_BROKER_HOST="mr6m7sc2dxasz.messaging.solace.cloud"
# export SOLACE_MGMT_MQTT_BROKER_PORT="1883"
# export SOLACE_MGMT_MQTT_BROKER_USER="solace-cloud-client"
# export SOLACE_MGMT_MQTT_BROKER_PASSWORD="me6ued0kqcka2br8dcf14t6qa5"
# export SOLACE_MGMT_MQTT_CLIENT_ID="NODE_RED_MGMT_APP_RJGU_DEV"
# #################################################
# # Solace Management Broker SEMPV2 Configuration
# #
# export SOLACE_MGMT_BROKER_SEMPV2_BASE_PATH="https://mr6m7sc2dxasz.messaging.solace.cloud:943/SEMP/v2/config"
# export SOLACE_MGMT_BROKER_SEMPV2_VPN="xdk-devices"
# export SOLACE_MGMT_BROKER_SEMPV2_VIRTUAL_ROUTER="primary"
# export SOLACE_MGMT_BROKER_SEMPV2_USER="xdk-devices-admin"
# export SOLACE_MGMT_BROKER_SEMPV2_PASSWORD="76pjp44265dv1fe370fr83bapq"
# export SOLACE_MGMT_BROKER_SEMPV2_IS_SOLACE_CLOUD="true"
#
# #################################################
# # Solace Device MQTT Broker Configuration
# #
# export SOLACE_DEVICE_MQTT_BROKER_HOST="mr6m7sc2dxasz.messaging.solace.cloud"
# export SOLACE_DEVICE_MQTT_BROKER_PORT="1883"
# export SOLACE_DEVICE_MQTT_BROKER_USER="solace-cloud-client"
# export SOLACE_DEVICE_MQTT_BROKER_PASSWORD="me6ued0kqcka2br8dcf14t6qa5"
# export SOLACE_DEVICE_MQTT_CLIENT_ID="NODE_RED_MGMT_APP_RJGU_DEV"
# #################################################
# # Solace Device Broker SEMPV2 Configuration
# #
# export SOLACE_DEVICE_BROKER_SEMPV2_BASE_PATH="https://mr6m7sc2dxasz.messaging.solace.cloud:943/SEMP/v2/config"
# export SOLACE_DEVICE_BROKER_SEMPV2_VPN="xdk-devices"
# export SOLACE_DEVICE_BROKER_SEMPV2_VIRTUAL_ROUTER="primary"
# export SOLACE_DEVICE_BROKER_SEMPV2_USER="xdk-devices-admin"
# export SOLACE_DEVICE_BROKER_SEMPV2_PASSWORD="76pjp44265dv1fe370fr83bapq"
# export SOLACE_DEVICE_BROKER_SEMPV2_IS_SOLACE_CLOUD="true"
#
#
# #################################################
# # Default device settings if used for first time
# #
# # optional
# #
# export DEFAULT_DEVICE_ID="24d11f0358cd5d9a"

#################################################
# Start node RED
#
# MBytes
#node --max_old_space_size=8192 /Users/rob/.nvm/versions/node/v10.11.0/bin/node-red
#cd node-red
#$ node --max-old-space-size=128 red.js
#node-red -s solace-xdk110-mgmt-settings.js
node --max-old-space-size=3072 /usr/local/bin/node-red -s till-integration-settings.js



# The End.

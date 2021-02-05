#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);

#####################################################################################
# settings
#

    WORKING_DIR="$scriptDir/tmp"

    deploymentDir="$WORKING_DIR/azure-deployment"
    settingsFile="$scriptDir/settings.json"
    settings=$(cat $settingsFile | jq .)
      projectName=$( echo $settings | jq -r '.projectName' )
      resourceGroup=$projectName

echo ">>> Deleting Azure Project: $projectName"
echo " >>> Deleting Resource Group $resourceGroup ..."
  az group delete \
    --name $resourceGroup \
    --verbose
  if [[ $? != 0 ]]; then echo " >>> ERROR: deleting resource group"; exit 1; fi
echo " >>> Success."

rm -rf $deploymentDir/*

###
# The End.

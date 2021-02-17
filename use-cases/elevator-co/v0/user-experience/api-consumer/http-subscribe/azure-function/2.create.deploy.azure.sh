#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);

#####################################################################################
# settings
#

  WORKING_DIR="$scriptDir/tmp"
  settingsFile="$scriptDir/settings.json"
  settings=$(cat $settingsFile | jq .)
  projectName=$( echo $settings | jq -r '.projectName' )

echo ">>> Create Azure Resources and Deploy Project: $projectName"
echo " >>> settings:"
echo $settings | jq

  echo; read -n 1 -p "- Press key to continue, CTRL-C to exit ..." x; echo;

runScript="$scriptDir/scripts/common.create.sh"; echo ">>> $runScript";
  $runScript; if [[ $? != 0 ]]; then echo ">>> ERROR:$runScript"; exit 1; fi
  cd $scriptDir

runScript="$scriptDir/scripts/rdp2blob.create.sh"; echo ">>> $runScript";
  $runScript; if [[ $? != 0 ]]; then echo ">>> ERROR:$runScript"; echo; exit 1; fi
  cd $scriptDir

  exit


runScript="$scriptDir/rdp2blob.create.broker-settings.sh"; echo ">>> $runScript";
  $runScript; if [[ $? != 0 ]]; then echo ">>> ERROR:$runScript"; echo; exit 1; fi
  cd $scriptDir

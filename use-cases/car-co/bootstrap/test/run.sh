#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Environment Variables

  source $scriptDir/test.source.env.sh

############################################################################################################################
# Prepare

  nodeVersion=$(node --version)
  LOG_DIR="$scriptDir/tmp/logs/$APIM_BOOTSTRAP_USE_CASE_NAME/node-$nodeVersion"; mkdir -p $LOG_DIR; rm -rf $LOG_DIR/*;

############################################################################################################################
# Run
  runScript="$scriptDir/common/test/run.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> ERROR - code=$code - runScript='$runScript' - $scriptName"; exit 1; fi

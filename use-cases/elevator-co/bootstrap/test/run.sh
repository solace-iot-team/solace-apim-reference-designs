#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Environment Variables

  source $scriptDir/test.source.env.sh
  if [ -z "$APIM_BOOTSTRAP_USE_CASE_NAME" ]; then echo ">>> ERROR: - $scriptName - missing env var: APIM_BOOTSTRAP_USE_CASE_NAME"; exit 1; fi

############################################################################################################################
# Prepare

  nodeVersion=$(node --version)
  LOG_DIR="$scriptDir/tmp/logs/$APIM_BOOTSTRAP_USE_CASE_NAME/node-$nodeVersion"; mkdir -p $LOG_DIR; rm -rf $LOG_DIR/*;

############################################################################################################################
# Scripts

  declare -a runScripts=(
    "$scriptDir/../bootstrap.apim-system.local.sh"
    "$scriptDir/run-test.sh"
  )

############################################################################################################################
# Run

  FAILED=0
  for runScript in ${runScripts[@]}; do
    if [ "$FAILED" -eq 0 ]; then
      echo "starting: $runScript ..."
      _dirname=$(dirname "$runScript")
      _logFile=${runScript#"$_dirname/"}
      logFile="$LOG_DIR/$_logFile.out"; mkdir -p "$(dirname "$logFile")";
      "$runScript" > $logFile 2>&1
      code=$?; if [[ $code != 0 ]]; then echo ">>> ERROR - code=$code - runScript='$runScript' - $scriptName"; FAILED=1; fi
    fi
  done

############################################################################################################################
# Get Container logs and stop server
  declare -a runScripts=(
    "$scriptDir/get-server-logs.sh"
    "$scriptDir/../teardown.apim-system.local.sh"
  )
  for runScript in ${runScripts[@]}; do
    echo "starting: $runScript ..."
    _dirname=$(dirname "$runScript")
    _logFile=${runScript#"$_dirname/"}
    logFile="$LOG_DIR/$_logFile.out"; mkdir -p "$(dirname "$logFile")";
    "$runScript" > $logFile 2>&1
    code=$?; if [[ $code != 0 ]]; then echo ">>> ERROR - code=$code - runScript='$runScript' - $scriptName"; FAILED=1; fi
  done

##############################################################################################################################
# Check for errors

if [[ "$FAILED" -eq 0 ]]; then
  echo ">>> FINISHED:SUCCESS - $scriptName"
  touch "$LOG_DIR/$scriptName.SUCCESS.out"
else
  echo ">>> FINISHED:FAILED";
  filePattern="$LOG_DIR"
  errors=$(grep -n -r -e "ERROR" $filePattern )
  if [ ! -z "$errors" ]; then
    while IFS= read line; do
      echo $line >> "$LOG_DIR/$scriptName.ERROR.out"
    done < <(printf '%s\n' "$errors")
  fi
  exit 1
fi

###
# The End.

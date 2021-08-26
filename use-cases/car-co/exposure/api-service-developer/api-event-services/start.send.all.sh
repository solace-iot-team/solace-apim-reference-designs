#!/usr/bin/env bash

scriptDir=$(cd $(dirname "$0") && pwd);
tmpDir="$scriptDir/tmp"
mkdir -p $tmpDir; rm -rf $tmpDir/*

echo
echo "Starting Sending all events ..."
echo


  runScript="consumption/send.consumption.sh"
  logFile="$tmpDir/consumption.out"
  nohup $runScript > $logFile 2>&1 &

  runScript="failure/send.failure.sh"
  logFile="$tmpDir/failure.out"
  nohup $runScript > $logFile 2>&1 &

  runScript="safety/send.safety.sh"
  logFile="$tmpDir/safety.out"
  nohup $runScript > $logFile 2>&1 &

# The End.

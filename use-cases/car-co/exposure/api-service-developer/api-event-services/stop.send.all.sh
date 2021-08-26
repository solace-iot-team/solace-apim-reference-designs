#!/usr/bin/env bash

scriptDir=$(cd $(dirname "$0") && pwd);
tmpDir="$scriptDir/tmp"
mkdir -p $tmpDir; rm -rf $tmpDir/*

echo
echo "Stop Sending processes ..."
echo

pids=$(ps -ef | grep send. | awk {'print $2'} )
for pid in ${pids[@]}; do
  echo "killing pid= '$pid'"
  kill -9 $pid
done




# The End.

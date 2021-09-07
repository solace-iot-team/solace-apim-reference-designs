#!/usr/bin/env bash
WORKING_DIR="$1/tmp";
CONTAINER_NAME=$2;

echo "   >>> check docker logs if server up ..."
echo "   WORKING_DIR=$WORKING_DIR"
echo "   CONTAINER_NAME=$CONTAINER_NAME"
    #clean working dir
    rm -rf $WORKING_DIR/*;
    dockerLogsFile="$WORKING_DIR/docker.logs"
    isInitialized=0; checks=0
    until [[ $isInitialized -gt 2 || $checks -gt 10 ]]; do
      ((checks++))
      echo "   check: $checks"
      docker logs $CONTAINER_NAME > $dockerLogsFile
      entryListeningOnPort=$(grep -n -e "Listening on port $PLATFORM_PORT" $dockerLogsFile)
      echo "      - entryListeningOnPort='$entryListeningOnPort'"
      if [ ! -z "$entryListeningOnPort" ]; then ((isInitialized++)); fi
      entryConnected2Mongo=$(grep -n -e "Connected to Mongo" $dockerLogsFile)
      echo "      - entryConnected2Mongo='$entryConnected2Mongo'"
      if [ ! -z "$entryConnected2Mongo" ]; then ((isInitialized++)); fi
      entryLoadedUserRegistry=$(grep -n -e "Loaded user registry" $dockerLogsFile)
      echo "      - entryLoadedUserRegistry='$entryLoadedUserRegistry'"
      if [ ! -z "$entryLoadedUserRegistry" ]; then ((isInitialized++)); fi
      if [ $isInitialized -lt 3 ]; then sleep 2s; fi
    done
    if [ $isInitialized -lt 3 ]; 
        then 
            echo " >>> ERROR: server is not initialized, checks=$checks"; 
            touch $WORKING_DIR/SERVER_NOT_INITIALIZED;
        else 
            echo " >>> SUCCESS: server is initialized, checks=$checks";
            touch $WORKING_DIR/SERVER_INITIALIZED;
    fi      

#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);

#####################################################################################
# settings
#
    WORKING_DIR="$scriptDir/tmp"
    releaseDir="$WORKING_DIR/release"
    releaseTmpDir="$releaseDir/tmp"

    releaseProject="solace-int-rdp-az-funcs"
    gitReleaseURL="https://api.github.com/repos/solace-iot-team/$releaseProject/releases"
    assetReleaseName="solace-rdp-2-blob"

    echo ">>> Downloading Azure Function zip release to $releaseDir"

#####################################################################################
# Prepare Dirs

    mkdir -p $WORKING_DIR; rm -rf $WORKING_DIR
    mkdir -p $releaseDir
    mkdir -p $releaseTmpDir

#####################################################################################
# Get latest release
#
    echo " >>> Get Latest Release ..."
    resp=$(curl \
        --silent \
        -H "Accept: application/vnd.github.v3+json" \
        "$gitReleaseURL/latest"
         )
         if [[ $? != 0 ]]; then echo " >>> ERR: get latest release info"; exit 1; fi

    releaseAssetInfo=$(echo $resp | jq -r '.assets[] | select(.name | contains("'"$assetReleaseName"'"))')
    # echo $releaseAssetInfo | jq
    tagName=$(echo $resp | jq -r '.tag_name')
    releaseAssetName=$(echo $releaseAssetInfo | jq -r '.name')
    downloadUrl=$(echo $releaseAssetInfo | jq -r '.browser_download_url')
    # echo "downloadUrl=$downloadUrl"
    cd $tmpDir
    resp=$(curl -L $downloadUrl --silent --output $releaseAssetName)
    unzip *.zip -d $releaseDir > /dev/null 2>&1
    echo " >>> done."

    rm -rf $releaseTmpDir

    echo " >>> Release Assets:"
    ls $releaseDir/*
    echo


###
# The End.

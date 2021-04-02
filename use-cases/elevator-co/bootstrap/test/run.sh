#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

############################################################################################################################
# Run

echo ">>> Npm install ..."
  cd $scriptDir
  runScript="npm install"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo " >>> ERROR - code=$code - runScript='$runScript' - $scriptName"; exit 1; fi
echo ">>> Success";

echo ">>> Run example test ..."
  cd "$scriptDir/.."
  source "test/test.source.env.sh"
  runScript="npm test"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo " >>> ERROR - code=$code - runScript='$runScript' - $scriptName"; exit 1; fi
echo ">>> Success";

###
# The End.

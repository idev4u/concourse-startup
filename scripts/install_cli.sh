#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/logging_cons.sh

DARWIN_URL="http://192.168.100.4:8080/api/v1/cli?arch=amd64&platform=darwin"

echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Check, if Concourse CLI is installed."
if [ -e fly ]; then
  echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "it is, nice."
else
  echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "ohh, it isn't. But will be download ..."
  if [ "$(uname)" == "Darwin" ]; then
    echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "You run macOS"
    echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Download fly from ${DARWIN_URL} for macOS"
    wget ${DARWIN_URL} -O fly
    chmod u+x fly
  fi
fi

./fly --version &>/dev/null

if [ ${?} = 0 ]; then
  echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Concourse CLI is succesfully installed."
else
  echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Ups, Concourse CLI is NOT installed."
fi

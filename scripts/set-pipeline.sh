#!/bin/bash
#set -e
#
# Setup Concourse Ci Config you need the fly cli
#
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/logging_cons.sh
echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Setup the pipeline ..."

# fly -t lite login -c http://192.168.100.4:8080
RETRY_COUNTER=0
echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Connect to the your concourse-ci"
IS_CONNECTED=false
while [ $RETRY_COUNTER -lt 10 ] && [ $IS_CONNECTED = false ] ; do

 	echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} The retry-counter is $RETRY_COUNTER
 	RESULT=$(./fly -t lite login -c http://192.168.100.4:8080)
 	echo "RESULT: "$RESULT
 	if [[ $RESULT == *"target saved"* ]]; then
 		echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Connection to the your concourse-ci is established"
 		IS_CONNECTED=true
 		break
	fi
	let RETRY_COUNTER=RETRY_COUNTER+1
	sleep $RETRY_COUNTER
done

if [ $IS_CONNECTED = false ]; then
	echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Concourse is NOT up."
	exit 1
fi

expect -c "
   set timeout 1
   spawn ./fly -t lite set-pipeline -p test-pipeline -c pipeline/pipeline.yml
   expect configuration
   send y\r
   sleep 1
   exit
"

printf "\n"
echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "unpause pipeline your pipeline"
./fly -t lite unpause-pipeline -p test-pipeline

echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "make the pipeline public visable"
./fly -t lite expose-pipeline --pipeline test-pipeline

if [ "$(uname)" == "Darwin" ]; then
   echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "open the ${AIRPLANE} pipeline in your default browser"
   open http://192.168.100.4:8080/ &
else
   echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "open the ${AIRPLANE} pipeline in your browser. http://192.168.100.4:8080"
fi

echo -e ${PREFIX_LOG} ${AIRPLANE} "Done, have fun with Concourse"
exit 0

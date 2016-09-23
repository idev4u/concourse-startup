#!/bin/bash

set -e

# export PREFIX_LOG="==> INFO:"
# # Gear Symbol
# export PREFIX_SYMBOL="\xE2\x9A\x99"
# export ROCKET="\xF0\x9F\x9A\x80"
# export AIRPLANE="\xE2\x9C\x88"
source scripts/logging_cons.sh
# globale boolean for checking if coucnourse is running
ISCONCOURSERUNNING=false

function vagrantStatus(){
	boxstate=$(vagrant status | grep default)
	#echo $boxstate
	if [[ $boxstate == *"running"* ]]; then
	 echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Concourse Box is running!"
	 #echo $(vagrant status | grep default)
	 ISCONCOURSERUNNING=true
	 #echo "${ISCONCOURSERUNNING}"
	elif [[ $boxstate == *"off"* ]]; then
	 echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Concourse is power off!"
	 #echo $(vagrant status | grep default)
	else
	 echo -e $PREFIX_LOG ${PREFIX_SYMBOL} "Ups, there is something strange! Concourse is not up!"
	 #echo $(vagrant status | grep default)
	fi
}


#
# check if vagrant is initialized
echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "checking if concourse already exist"
if [ ! -e "Vagrantfile" ]; then
	echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "No Vagrantfile! OK it will be downloaded ..."
	vagrant init concourse/lite
else
	echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Yes! It's already there."
fi
#
# check status of vm
vagrantStatus

#
# check if Concourse machine already up
echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "checking if concourse is already running"
#echo "${ISCONCOURSERUNNING}"
if [ "${ISCONCOURSERUNNING}" = true ];  then
	#echo "${ISCONCOURSERUNNING}"
	echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Yes! Concourse already up."
	exit 1
else
	echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Yes! Concourse is NOT already up."
fi

echo -e ${PREFIX_LOG} ${ROCKET} " Startup Concourse"

#
# start vagrant
vagrant up

#
# check status of vm
vagrantStatus

#--------------------------------------------------------------------------------------------------------
#
# Setup Concourse Ci Config you need the fly cli
#
echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Setup the pipeline ..."
./scripts/install_cli.sh
./scripts/set-pipeline.sh
# fly -t lite login -c http://192.168.100.4:8080
# RETRY_COUNTER=0
# echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Connect to the your concourse-ci"
# IS_CONNECTED=false
# while [ $RETRY_COUNTER -lt 10 ] && [ $IS_CONNECTED = false ] ; do

#  	echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} The retry-counter is $RETRY_COUNTER
#  	RESULT=$(fly -t lite login -c http://192.168.100.4:8080)
#  	echo "RESULT: "$RESULT
#  	if [[ $RESULT == *"target saved"* ]]; then
#  		echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Connection to the your concourse-ci is established"
#  		IS_CONNECTED=true
#  		break
# 	fi
# 	let RETRY_COUNTER=RETRY_COUNTER+1
# 	sleep $RETRY_COUNTER
# done

# if [ $IS_CONNECTED = false ]; then
# 	echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "Concourse is NOT up."
# 	exit 1
# fi

# expect -c "
#    set timeout 1
#    spawn fly -t lite set-pipeline -p test-pipeline -c pipeline/pipeline.yml
#    expect configuration
#    send y\r
#    sleep 1
#    exit
# "

# printf "\n"
# echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "unpause pipeline your pipeline"
# fly -t lite unpause-pipeline -p test-pipeline

# echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "make the pipeline public visable"
# fly -t lite expose-pipeline --pipeline test-pipeline

# echo -e ${PREFIX_LOG} ${PREFIX_SYMBOL} "open the ${AIRPLANE} pipeline in your default browser"
# open http://192.168.100.4:8080/ &

# echo -e ${PREFIX_LOG} ${AIRPLANE} "Done, have fun with Concourse"
exit 0

#!/bin/sh

getApplicationFoldername() {
	SCRIPT_FILE=`basename $0`
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		echo "ERR: $RESULT: Error encountered while determining the name of the current script."
		return $RESULT;
	fi
	
	SCRIPT_FOLDER=`dirname $0`;
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		echo "ERR: $RESULT: Error encountered while determining the name of the folder containing the current script."
		return $RESULT;
	fi
	
	if [ "$SCRIPT_FOLDER" = "" ] || [ "$SCRIPT_FOLDER" = "." ] || [ -z "$SCRIPT_FOLDER" ]; then
			SCRIPT_FOLDER=`pwd`
	fi

	return 0
}

initialiseEnvironment() {	
	getApplicationFoldername
	if [ $? -ne 0 ]; then
		return $?
	fi
	
	return 0
}

main() {
	initialiseEnvironment
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		return $RESULT
	fi
	
	return 0
}

main

VAGRANT_FOLDER=/vagrant
SOFTWARE_FOLDER=$VAGRANT_FOLDER/../../software
ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME=/etc/environment

echo VAGRANT_FOLDER:$VAGRANT_FOLDER.
echo SOFTWARE_FOLDER:$SOFTWARE_FOLDER.
echo ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME:$ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME

sudo hostname localhost
sudo sh -c "echo localhost > /etc/hostname"

$SOFTWARE_FOLDER/install-jdk.sh
. $ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME
$SOFTWARE_FOLDER/install-maven.sh
. $ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME
$SOFTWARE_FOLDER/install-node-and-bower.sh
. $ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME
npm install -g bower
$SOFTWARE_FOLDER/install-git.sh
$SOFTWARE_FOLDER/install-eclipse.sh
$SOFTWARE_FOLDER/install-google-chrome.sh
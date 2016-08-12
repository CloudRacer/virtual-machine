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

echo VAGRANT_FOLDER:$VAGRANT_FOLDER.

sudo hostname localhost
sudo sh -c "echo localhost > /etc/hostname"

#sudo sh -c "echo 'Defaults env_keep += \"PATH JAVA_HOME\"' >> /etc/sudoers"

$SOFTWARE_FOLDER/install-jdk.sh
$SOFTWARE_FOLDER/install-maven.sh
$SOFTWARE_FOLDER/install-eclipse.sh

sudo apt-get -y install git
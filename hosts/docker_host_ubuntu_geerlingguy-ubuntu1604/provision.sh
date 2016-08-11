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
SOFTWARE_FOLDER=/software

echo VAGRANT_FOLDER:$VAGRANT_FOLDER.
echo SOFTWARE_FOLDER:$SOFTWARE_FOLDER.

cd "$VAGRANT_FOLDER"

#git clone https://github.com/bofm/docker-oracle12c.git
#cd "$VAGRANT_FOLDER/docker-oracle12c"
#make all
$SOFTWARE_FOLDER/install-docker.sh
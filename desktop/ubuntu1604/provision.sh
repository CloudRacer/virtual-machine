#!/bin/sh

setScriptFilename() {
	SCRIPT_FILE=`basename $0`
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		echo "ERR: $RESULT: Error encountered while determining the name of the current script."
		return $RESULT;
	fi

	return 0
}

setScriptFolderName() {
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

initialiseEnvironmentVariables() {
    if [ ! -z "$ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME" ]; then
        if [ -f $ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME ]; then
            . $ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME
            RESULT=$?
            if [ $RESULT -ne 0 ]; then
                return $RESULT
            fi
        fi
    fi

	return 0
}

initialiseEnvironment() {
    initialiseEnvironmentVariables
    RESULT=$?
    if [ $RESULT -ne 0 ]; then
        return $RESULT
    fi

	setScriptFilename
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		return $RESULT
	fi
	
	setScriptFolderName
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		return $RESULT
	fi
	
	return 0
}

finalise() {
    initialiseEnvironmentVariables
    RESULT=$?
    if [ $RESULT -ne 0 ]; then
        return $RESULT
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
echo ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME:$ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME.

sudo hostname localhost
sudo sh -c "echo localhost > /etc/hostname"

sh $VAGRANT_FOLDER/auto-login.sh
initialiseEnvironmentVariables

sh $SOFTWARE_FOLDER/install-jdk.sh
initialiseEnvironmentVariables
sh $SOFTWARE_FOLDER/install-maven.sh
initialiseEnvironmentVariables
sh $SOFTWARE_FOLDER/install-node.sh
initialiseEnvironmentVariables
sh $SOFTWARE_FOLDER/install-git.sh
initialiseEnvironmentVariables
sh $SOFTWARE_FOLDER/install-eclipse.sh
initialiseEnvironmentVariables
sh $SOFTWARE_FOLDER/install-google-chrome.sh
initialiseEnvironmentVariables

# Install bower.
npm install -g bower

finalise

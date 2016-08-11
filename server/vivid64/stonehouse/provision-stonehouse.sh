#!/bin/sh

setScriptFilename() {
	SCRIPT_FILE=`basename $0`
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		echo "ERR: $RESULT: Error encountered while determining the name of the current script."
		return $RESULT;
	fi

	echo SCRIPT_FILE:$SCRIPT_FILE.

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

	echo SCRIPT_FOLDER:$SCRIPT_FOLDER.

	return 0
}

initialiseEnvironment() {
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

main() {
	initialiseEnvironment
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		return $RESULT
	fi

	return 0
}

main
RESULT=$?
if [ $RESULT -ne 0 ]; then
	return $RESULT
fi

APPLICATION_NAME=stonehouse
APPLICATION_VERSION=1.0-SNAPSHOT
APPLICATION_TAR_FILE=$SCRIPT_FOLDER/stonehouse-1.0-SNAPSHOT-install.tar
TEMPORARY_TAR_FILE=$SCRIPT_FOLDER/tmp.tar
APPLICATION_GZ_FILE=$APPLICATION_TAR_FILE.gz
APPLICATION_UNZIP_FOLDER=$SCRIPT_FOLDER/install
APPLICATION_DESTINATION_FOLDERNAME=/lib/systemd/system
APPLICATION_SERVICE_FILENAME=$APPLICATION_NAME.service
DAEMON_SCRIPT=$APPLICATION_NAME
CONF_FILE=$APPLICATION_NAME.conf

echo APPLICATION_NAME:$APPLICATION_NAME.
echo APPLICATION_VERSION:$APPLICATION_VERSION.
echo APPLICATION_TAR_FILE:$APPLICATION_TAR_FILE.
echo APPLICATION_GZ_FILE:$APPLICATION_GZ_FILE.
echo APPLICATION_UNZIP_FOLDER:$APPLICATION_UNZIP_FOLDER.
echo APPLICATION_DESTINATION_FOLDERNAME:$APPLICATION_DESTINATION_FOLDERNAME.
echo APPLICATION_SERVICE_FILENAME:$APPLICATION_SERVICE_FILENAME.
echo DAEMON_SCRIPT:$DAEMON_SCRIPT.
echo CONF_FILE:$CONF_FILE.

if [ -f "$APPLICATION_GZ_FILE" ]; then
    if [ -d "$APPLICATION_UNZIP_FOLDER" ]; then
        rm -R $APPLICATION_UNZIP_FOLDER
    fi
    if [ -f "$APPLICATION_TAR_FILE" ]; then
        rm -f $APPLICATION_TAR_FILE
    fi

    cp -f $APPLICATION_GZ_FILE $TEMPORARY_TAR_FILE.gz
    gunzip $TEMPORARY_TAR_FILE.gz
    tar -xf $TEMPORARY_TAR_FILE
    mv $APPLICATION_NAME-$APPLICATION_VERSION $APPLICATION_UNZIP_FOLDER
    
    rm -f $TEMPORARY_TAR_FILE
fi

sh $APPLICATION_UNZIP_FOLDER/install.sh
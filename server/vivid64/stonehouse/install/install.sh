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
APPLICATION_DESTINATION_FOLDER_NAME=/$APPLICATION_NAME

/usr/bin/docker run \
    --name=$APPLICATION_NAME \
    -v $SCRIPT_FOLDER:$APPLICATION_DESTINATION_FOLDER_NAME \
    --expose=8080 --publish=8080:8080 \
    --restart="always" \
    --detach=true \
    java:latest \
    java -jar $APPLICATION_DESTINATION_FOLDER_NAME/$APPLICATION_NAME-1.0-SNAPSHOT.jar

exit $?
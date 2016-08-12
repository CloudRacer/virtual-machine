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

INSTALL_FOLDER=/opt/maven
SOURCE_FILENAME=apache-maven-3.3.9-bin.tar.gz
SOFTWARE_DOWNLOAD_URL=http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/3.3.9/binaries/$SOURCE_FILENAME
SOFTWARE_HOME=$INSTALL_FOLDER/default
UTILITY_FETCH_FOLDER=$SCRIPT_FOLDER/fetch.sh
UTILITY_UNPACK_FOLDER=$SCRIPT_FOLDER/unpack.sh
UTILITY_ENV_VAR_UPDATE=$SCRIPT_FOLDER/environment-variable-update.sh
ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME=/etc/environment

echo INSTALL_FOLDER:$INSTALL_FOLDER.
echo SOURCE_FILENAME:$SOURCE_FILENAME.
echo SOFTWARE_DOWNLOAD_URL:$SOFTWARE_DOWNLOAD_URL.
echo SOFTWARE_HOME:$SOFTWARE_HOME.
echo UTILITY_FETCH_FOLDER:$UTILITY_FETCH_FOLDER.
echo UTILITY_UNPACK_FOLDER:$UTILITY_UNPACK_FOLDER.
echo UTILITY_ENV_VAR_UPDATE:$UTILITY_ENV_VAR_UPDATE.
echo ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME:$ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME.

echo
echo
echo

"$UTILITY_FETCH_FOLDER" "$SOFTWARE_DOWNLOAD_URL"
sudo "$UTILITY_UNPACK_FOLDER" "$SOURCE_FILENAME" "$INSTALL_FOLDER"
for file in `ls $INSTALL_FOLDER`; do
    echo "Renaming the \"$INSTALL_FOLDER/$file\" \"$INSTALL_FOLDER/default\"..."
    sudo mv "$INSTALL_FOLDER/$file" "$SOFTWARE_HOME"
done

"$UTILITY_ENV_VAR_UPDATE" "PATH" "$PATH:$SOFTWARE_HOME/bin"
. $ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME
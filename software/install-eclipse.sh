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

APPLICATION_NAME=eclipse
INSTALL_FOLDER=/opt/$APPLICATION_NAME
SOURCE_FILENAME=eclipse-jee-mars-R-linux-gtk-x86_64.tar.gz
SOFTWARE_DOWNLOAD_URL=http://mirror.ibcp.fr/pub/eclipse//technology/epp/downloads/release/mars/R/$SOURCE_FILENAME
SOFTWARE_HOME=$INSTALL_FOLDER/default
SOFTWARE_LINK=/usr/bin/$APPLICATION_NAME
UTILITY_FETCH_FOLDER=$SCRIPT_FOLDER/fetch.sh
UTILITY_UNPACK_FOLDER=$SCRIPT_FOLDER/unpack.sh
UTILITY_ENV_VAR_CREATE=$SCRIPT_FOLDER/environment-variable-create.sh
UTILITY_ENV_VAR_UPDATE=$SCRIPT_FOLDER/environment-variable-update.sh

echo APPLICATION_NAME:$APPLICATION_NAME.
echo INSTALL_FOLDER:$INSTALL_FOLDER.
echo SOURCE_FILENAME:$SOURCE_FILENAME.
echo SOFTWARE_DOWNLOAD_URL:$SOFTWARE_DOWNLOAD_URL.
echo SOFTWARE_HOME:$SOFTWARE_HOME.
echo SOFTWARE_LINK:$SOFTWARE_LINK.
echo UTILITY_UNPACK_FOLDER:$UTILITY_UNPACK_FOLDER.
echo UTILITY_ENV_VAR_CREATE:$UTILITY_ENV_VAR_CREATE.
echo UTILITY_ENV_VAR_UPDATE:$UTILITY_ENV_VAR_UPDATE.

echo
echo
echo

"$UTILITY_FETCH_FOLDER" "$SOFTWARE_DOWNLOAD_URL"
sudo "$UTILITY_UNPACK_FOLDER" "$SOURCE_FILENAME" "$INSTALL_FOLDER"
for file in `ls $INSTALL_FOLDER`; do
    echo "Renaming the \"$INSTALL_FOLDER/$file\" \"$INSTALL_FOLDER/default\"..."
    sudo mv "$INSTALL_FOLDER/$file" "$SOFTWARE_HOME"
done

echo "Creating the link \"$SOFTWARE_LINK\" to the executable \"$SOFTWARE_HOME/$APPLICATION_NAME\"..."
if [ -f "$SOFTWARE_LINK" ]; then
    sudo rm "$SOFTWARE_LINK"
fi
sudo ln -s "$SOFTWARE_HOME/$APPLICATION_NAME" "$SOFTWARE_LINK"
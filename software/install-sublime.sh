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
RESULT=$?
if [ $RESULT -ne 0 ]; then
	return $RESULT
fi

APPLICATION_NAME=sublime_text
SOFTWARE_LINK=/usr/bin/$APPLICATION_NAME
INSTALL_FOLDER=/opt/sublime
SOURCE_FILENAME=Sublime%20Text%202.0.2%20x64.tar.bz2
SOFTWARE_DOWNLOAD_URL=https://download.sublimetext.com/$SOURCE_FILENAME
SOFTWARE_HOME=$INSTALL_FOLDER/default
UTILITY_FETCH_FOLDER=$SCRIPT_FOLDER/fetch.sh
UTILITY_UNPACK_FOLDER=$SCRIPT_FOLDER/unpack.sh
ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME=/etc/environment

echo INSTALL_FOLDER:$INSTALL_FOLDER.
echo SOURCE_FILENAME:$SOURCE_FILENAME.
echo SOFTWARE_DOWNLOAD_URL:$SOFTWARE_DOWNLOAD_URL.
echo SOFTWARE_HOME:$SOFTWARE_HOME.
echo UTILITY_FETCH_FOLDER:$UTILITY_FETCH_FOLDER.
echo UTILITY_UNPACK_FOLDER:$UTILITY_UNPACK_FOLDER.
echo ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME:$ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME.

echo
echo
echo

"$UTILITY_FETCH_FOLDER" "$SOFTWARE_DOWNLOAD_URL"
SOURCE_FILENAME=`echo $SOURCE_FILENAME | sed -e 's/%20/ /g' | tr ' ' '_' | tr -d '[{}(),\!]' | tr -d "\'" | sed 's/_-_/_/g'`

sudo "$UTILITY_UNPACK_FOLDER" "$SOURCE_FILENAME" "$INSTALL_FOLDER"
find "$INSTALL_FOLDER" -maxdepth 1 -type d | while read -r FILE
do
    if [ ! "$FILE" = "$INSTALL_FOLDER" ]; then
        echo Moving the folder "$FILE" to "$SOFTWARE_HOME"...
        sudo mv "$FILE" "$SOFTWARE_HOME"
    fi
done
sudo ln -s "$SOFTWARE_HOME/$APPLICATION_NAME" "$SOFTWARE_LINK"

finalise

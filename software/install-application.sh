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

APPLICATION_NAME=$1
SOFTWARE_LINK=/usr/bin/$APPLICATION_NAME
INSTALL_FOLDER=/opt/$APPLICATION_NAME
SOFTWARE_DOWNLOAD_URL=$2
SOURCE_FILENAME=`basename $SOFTWARE_DOWNLOAD_URL`
SOFTWARE_HOME=$INSTALL_FOLDER/default
APPLICATION_EXECUTABLE_NAME=$3
APPLICATION_EXECUTABLE=$SOFTWARE_HOME/$APPLICATION_EXECUTABLE_NAME
UTILITY_FETCH_FOLDER=$SCRIPT_FOLDER/download.sh
UTILITY_UNPACK_FOLDER=$SCRIPT_FOLDER/unpack.sh
ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME=/etc/environment

#echo APPLICATION_NAME:$APPLICATION_NAME.
#echo SOFTWARE_LINK:$SOFTWARE_LINK.
#echo INSTALL_FOLDER:$INSTALL_FOLDER.
#echo SOFTWARE_DOWNLOAD_URL:$SOFTWARE_DOWNLOAD_URL.
#echo SOURCE_FILENAME:$SOURCE_FILENAME.
#echo SOFTWARE_HOME:$SOFTWARE_HOME.
#echo APPLICATION_EXECUTABLE:$APPLICATION_EXECUTABLE.
#echo UTILITY_FETCH_FOLDER:$UTILITY_FETCH_FOLDER.
#echo UTILITY_UNPACK_FOLDER:$UTILITY_UNPACK_FOLDER.
#echo ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME:$ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME.

"$UTILITY_FETCH_FOLDER" "$SOFTWARE_DOWNLOAD_URL"

if [ ! -d "$INSTALL_FOLDER" ]; then
	SOURCE_FILENAME=`echo $SOURCE_FILENAME | sed -e 's/%20/ /g' | tr ' ' '_' | tr -d '[{}(),\!]' | tr -d "\'" | sed 's/_-_/_/g'`

	echo "Installing \"$SOURCE_FILENAME\" into \"$INSTALL_FOLDER\"..."

	sudo "$UTILITY_UNPACK_FOLDER" "$SOURCE_FILENAME" "$INSTALL_FOLDER"
	find "$INSTALL_FOLDER" -maxdepth 1 -type d | while read -r FILE
	do
	    if [ ! "$FILE" = "$INSTALL_FOLDER" ]; then
	        echo Moving the folder "$FILE" to "$SOFTWARE_HOME"...
	        sudo mv "$FILE" "$SOFTWARE_HOME"
	    fi
	done
else
	echo The application folder \"$INSTALL_FOLDER\" already exists.
fi


if [ ! "$APPLICATION_EXECUTABLE_NAME" = "" ]; then
	# Identify the link file, even if it is broken.
	if [ -L "$SOFTWARE_LINK" ]; then
		echo Removing the pre-existing Symbolic Link \"$SOFTWARE_LINK\"...
		sudo rm "$SOFTWARE_LINK"
	fi
	echo Creating the Symbolic Link \"$SOFTWARE_LINK\" to \"$APPLICATION_EXECUTABLE\"...
	sudo ln -s "$APPLICATION_EXECUTABLE" "$SOFTWARE_LINK"
else
	echo Application executable not specified\; a Symbolic Link will not be created.
fi

finalise

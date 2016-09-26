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

SOFTWARE_NAME=$( eval "echo $1" )
INSTALL_FOLDER=$( eval "echo $2" )
REPOSITORY_ARCHIVE=$SCRIPT_FOLDER/repository
REPOSITORY_SOFTWARE_ARCHIVE=$REPOSITORY_ARCHIVE/$SOFTWARE_NAME/$SOFTWARE_NAME
REPOSITORY_SOFTWARE_ARCHIVE_EXTENSION=${REPOSITORY_SOFTWARE_ARCHIVE##*.}
DEB_FILE_EXTENSION="deb"
BZ2_FILE_EXTENSION="bz2"
gz_FILE_EXTENSION="gz"
UTILITY_CREATE_FOLDER=$SCRIPT_FOLDER/create-folder.sh
UTILITY_DELETE_FOLDER=$SCRIPT_FOLDER/delete-folder.sh
UTILITY_CLEAN_FILENAME=$SCRIPT_FOLDER/clean_filename.sh

echo SOFTWARE_NAME:$SOFTWARE_NAME.
echo INSTALL_FOLDER:$INSTALL_FOLDER.
echo REPOSITORY_SOFTWARE_ARCHIVE:$REPOSITORY_SOFTWARE_ARCHIVE.
echo REPOSITORY_SOFTWARE_ARCHIVE_EXTENSION:$REPOSITORY_SOFTWARE_ARCHIVE_EXTENSION.
echo DEB_FILE_EXTENSION:$DEB_FILE_EXTENSION.
echo BZ2_FILE_EXTENSION:$BZ2_FILE_EXTENSION.

"$UTILITY_DELETE_FOLDER" "$INSTALL_FOLDER" 
"$UTILITY_CREATE_FOLDER" "$INSTALL_FOLDER"
cd "$INSTALL_FOLDER"

echo;echo;echo;echo "Unpacking the \"$REPOSITORY_SOFTWARE_ARCHIVE_EXTENSION\" bundle \"$REPOSITORY_SOFTWARE_ARCHIVE\" to the folder \"$INSTALL_FOLDER\"..."
if [ "$REPOSITORY_SOFTWARE_ARCHIVE_EXTENSION" = "$DEB_FILE_EXTENSION" ]; then
    sudo dpkg-deb --extract "$REPOSITORY_SOFTWARE_ARCHIVE" "."
elif [ "$REPOSITORY_SOFTWARE_ARCHIVE_EXTENSION" = "$BZ2_FILE_EXTENSION" ]; then
    sudo tar -jxf "$REPOSITORY_SOFTWARE_ARCHIVE"
elif [ "$REPOSITORY_SOFTWARE_ARCHIVE_EXTENSION" = "$gz_FILE_EXTENSION" ]; then
    sudo tar -xzf "$REPOSITORY_SOFTWARE_ARCHIVE"
else
    sudo tar -xf "$REPOSITORY_SOFTWARE_ARCHIVE"
fi

"$UTILITY_CLEAN_FILENAME" "$REPOSITORY_ARCHIVE"

finalise

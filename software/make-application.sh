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
SOFTWARE_DOWNLOAD_URL=$2
RANDOM=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32`
REPOSITORY_ARCHIVE=$SCRIPT_FOLDER/repository
SOURCE_ARCHIVE_FILENAME=$APPLICATION_NAME-source.tar.gz
REPOSITORY_SOFTWARE_FOLDER=$REPOSITORY_ARCHIVE/$APPLICATION_NAME
REPOSITORY_SOURCE_FOLDER=$REPOSITORY_ARCHIVE/$SOURCE_ARCHIVE_FILENAME
REPOSITORY_SOFTWARE_ARCHIVE_FILENAME=$APPLICATION_NAME.tar.bz2
TEMP_FOLDER=/tmp/$RANDOM
SOURCE_HOME_FOLDER=$TEMP_FOLDER/src
SOURCE_FOLDER=$SOURCE_HOME_FOLDER/git
SOURCE_ARCHIVE=$SOURCE_HOME_FOLDER/git/$SOURCE_ARCHIVE_FILENAME
UTILITY_CREATE_FOLDER=$SCRIPT_FOLDER/create-folder.sh
UTILITY_DELETE_FOLDER=$SCRIPT_FOLDER/delete-folder.sh
UTILITY_FETCH_FOLDER=$SCRIPT_FOLDER/fetch.sh
UTILITY_UNPACK_FOLDER=$SCRIPT_FOLDER/unpack.sh
TAR_UTILITY="tar -cvjSf"

echo;echo;echo
echo APPLICATION_NAME=$APPLICATION_NAME.
echo SOFTWARE_DOWNLOAD_URL:$SOFTWARE_DOWNLOAD_URL.
echo RANDOM=$RANDOM.
echo REPOSITORY_ARCHIVE=$REPOSITORY_ARCHIVE.
echo REPOSITORY_SOFTWARE_FOLDER=$REPOSITORY_SOFTWARE_FOLDER.
echo REPOSITORY_SOURCE_FOLDER:$REPOSITORY_SOURCE_FOLDER.
echo REPOSITORY_SOFTWARE_ARCHIVE_FILENAME=$REPOSITORY_SOFTWARE_ARCHIVE_FILENAME.
echo SOURCE_HOME_FOLDER=$SOURCE_HOME_FOLDER.
echo SOURCE_FOLDER=$SOURCE_FOLDER.
echo SOURCE_ARCHIVE_FILENAME=$SOURCE_ARCHIVE_FILENAME.
echo SOURCE_ARCHIVE=$SOURCE_ARCHIVE.
echo UTILITY_CREATE_FOLDER:$UTILITY_CREATE_FOLDER.
echo UTILITY_DELETE_FOLDER=$UTILITY_DELETE_FOLDER.
echo UTILITY_FETCH_FOLDER=$UTILITY_FETCH_FOLDER.
echo UTILITY_UNPACK_FOLDER=$UTILITY_UNPACK_FOLDER.
echo TAR_UTILITY:$TAR_UTILITY.

if [ ! -d "$REPOSITORY_SOURCE_FOLDER" ]; then
    "$UTILITY_FETCH_FOLDER" "$SOFTWARE_DOWNLOAD_URL" "$SOURCE_ARCHIVE_FILENAME"
fi

if [ ! -d "$REPOSITORY_SOFTWARE_FOLDER" ]; then
    "$UTILITY_UNPACK_FOLDER" "$SOURCE_ARCHIVE_FILENAME" "$SOURCE_FOLDER"
    find "$SOURCE_FOLDER" -maxdepth 1 -type d | while read -r FILE
    do
        if [ ! "$FILE/$APPLICATION_NAME" = "$SOURCE_FOLDER/$APPLICATION_NAME" ]; then
            echo Renaming the folder "$FILE" to "$SOURCE_FOLDER/$APPLICATION_NAME"...
            sudo mv "$FILE" "$SOURCE_FOLDER/$APPLICATION_NAME"
        fi
    done
    cd "$SOURCE_FOLDER/$APPLICATION_NAME"

    #https://groups.google.com/forum/#!topic/git-users/5WmbkNPDk3I
    sudo make configure
    sudo ./configure --prefix=/usr
    sudo make all doc info
    sudo make install install-doc install-html install-info

    "$UTILITY_DELETE_FOLDER" "$REPOSITORY_SOFTWARE_FOLDER"
    cd "$SOURCE_FOLDER"
    sudo $TAR_UTILITY "$REPOSITORY_SOFTWARE_ARCHIVE_FILENAME" "$APPLICATION_NAME"
    sudo "$UTILITY_CREATE_FOLDER" "$REPOSITORY_SOFTWARE_FOLDER"
    sudo mv "$REPOSITORY_SOFTWARE_ARCHIVE_FILENAME" "$REPOSITORY_SOFTWARE_FOLDER"
    "$UTILITY_DELETE_FOLDER" "$TEMP_FOLDER"
else
    echo;echo;echo
    echo The source folder \"$REPOSITORY_SOURCE_FOLDER\" already exists.
fi
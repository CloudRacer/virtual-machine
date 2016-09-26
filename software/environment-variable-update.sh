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

initialiseEnvironmentVariables

ENVIRONMENT_VARIABLE_NAME=$1
ENVIRONMENT_VARIABLE_VALUE=$( eval "echo $2" )
ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME=/etc/environment
ENVIRONMENT_VARIABLE_ALREADY_EXISTS=`cat $ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME | grep $ENVIRONMENT_VARIABLE_NAME | wc --lines`
UTILITY_ENV_VAR_CREATE=$SCRIPT_FOLDER/environment-variable-create.sh

echo ENVIRONMENT_VARIABLE_ALREADY_EXISTS:$ENVIRONMENT_VARIABLE_ALREADY_EXISTS.

initialiseEnvironmentVariables

if [ $ENVIRONMENT_VARIABLE_ALREADY_EXISTS -ne 0 ]; then
	FOLDER_ALREADY_IN_PATH=0

	if [ "$ENVIRONMENT_VARIABLE_NAME" = "PATH" ]; then
		LAST_ENTRY_OF_PATH=`echo ${ENVIRONMENT_VARIABLE_VALUE##*:}`
		FOLDER_ALREADY_IN_PATH=`echo $PATH | grep $LAST_ENTRY_OF_PATH | wc --lines`
	fi
	echo FOLDER_ALREADY_IN_PATH:$FOLDER_ALREADY_IN_PATH.
	if [ $FOLDER_ALREADY_IN_PATH -ne 0 ]; then
		echo "\"$LAST_ENTRY_OF_PATH\" is already in the path."
	else
		echo "Updating the $ENVIRONMENT_VARIABLE_NAME environment variable in the file \"$ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME\"..."
		sudo sed -i "s@^\($ENVIRONMENT_VARIABLE_NAME=\).*@\1\"$ENVIRONMENT_VARIABLE_VALUE\"@" "$ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME"
	fi
else
	"$UTILITY_ENV_VAR_CREATE" $ENVIRONMENT_VARIABLE_NAME $ENVIRONMENT_VARIABLE_VALUE
fi

finalise

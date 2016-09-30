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

INSTALL_LIST=$SCRIPT_FOLDER/`echo install.list | cut -f 1 -d '.'`.list
UTILITY_INSTALL_APPLICATION=$SCRIPT_FOLDER/install-application.sh
UTILITY_ENV_VAR_UPDATE=$SCRIPT_FOLDER/environment-variable-update.sh
SCRIPT_MAKE=$SCRIPT_FOLDER/make.sh
ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME=/etc/environment

#echo INSTALL_LIST:$INSTALL_LIST.
#echo UTILITY_INSTALL_APPLICATION:$UTILITY_INSTALL_APPLICATION.
#echo UTILITY_ENV_VAR_UPDATE:$UTILITY_ENV_VAR_UPDATE.
#echo SCRIPT_MAKE:$SCRIPT_MAKE.
#echo ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME:$ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME.

$SCRIPT_MAKE

initialiseEnvironmentVariables

IFS=","
while read NAME URL EXE PARAM1 PARAM2 PARAM3 PARAM4 PARAM5 PARAM6
do
	COMMENTED_NAME=`echo "$NAME" | cut -f 1 -d '#'`
	if [ "$COMMENTED_NAME" = "$NAME" ]; then
		echo; echo; echo; echo "Installing \"$NAME\" from \"$URL\"..."
		"$UTILITY_INSTALL_APPLICATION" "$NAME" "$URL" "$EXE"

		if [ "$PARAM1" = "env" ]; then
	    		"$UTILITY_ENV_VAR_UPDATE" $PARAM2 $PARAM3

			initialiseEnvironmentVariables
			if [ "$PARAM4" = "env" ]; then
		    		"$UTILITY_ENV_VAR_UPDATE" $PARAM5 $PARAM6

				initialiseEnvironmentVariables
			fi
		fi
	else
    		echo; echo; echo; echo "Skipped \"$NAME\"."
	fi
done < "$INSTALL_LIST"

if [ -f "/usr/bin/nodejs" ]; then
	sudo npm install -g bower
fi

finalise

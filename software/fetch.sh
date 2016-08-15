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

URL=$1
FILENAME=$(basename "$URL")
REPOSITORY_SOFTWARE_FOLDER=$SCRIPT_FOLDER/repository/$FILENAME
UTILITY_CREATE_FOLDER=$SCRIPT_FOLDER/create-folder.sh
INSTALL_SCRIPT_NAME=$REPOSITORY_SOFTWARE_FOLDER/install.sh

if [ -f "$REPOSITORY_SOFTWARE_FOLDER/$FILENAME" ]; then
    echo "Software \"$REPOSITORY_SOFTWARE_FOLDER/$FILENAME\" already exists."
else
    "$UTILITY_CREATE_FOLDER" "$REPOSITORY_SOFTWARE_FOLDER"

    if [ ! -f "$JDK_BINARY" ]; then
        echo "#!/bin/sh" > "$INSTALL_SCRIPT_NAME"
        echo "SCRIPT_FOLDER=\`dirname \$0\`;" >> "$INSTALL_SCRIPT_NAME"
       	echo "if [ \"\$SCRIPT_FOLDER\" = \"\" ] || [ \"\$SCRIPT_FOLDER\" = \".\" ] || [ -z \"\$SCRIPT_FOLDER\" ]; then" >> "$INSTALL_SCRIPT_NAME"
        echo "    SCRIPT_FOLDER=\`pwd\`" >> "$INSTALL_SCRIPT_NAME"
        echo "fi" >> "$INSTALL_SCRIPT_NAME"
        echo "SOFTWARE_NAME=\`basename \$SCRIPT_FOLDER\`" >> "$INSTALL_SCRIPT_NAME"
        echo "echo" >> "$INSTALL_SCRIPT_NAME"
        echo "echo" >> "$INSTALL_SCRIPT_NAME"
        echo "echo" >> "$INSTALL_SCRIPT_NAME"
        echo "echo SCRIPT_FOLDER:\$SCRIPT_FOLDER." >> "$INSTALL_SCRIPT_NAME"
        echo "echo SOFTWARE_NAME:\$SOFTWARE_NAME." >> "$INSTALL_SCRIPT_NAME"
        echo "SOFTWARE_NAME=\`basename \$SCRIPT_FOLDER\`" >> "$INSTALL_SCRIPT_NAME"
        echo "cd \"\$SCRIPT_FOLDER\"" >> "$INSTALL_SCRIPT_NAME"
        echo "rm -f \"\$SCRIPT_FOLDER/\$SOFTWARE_NAME\"" >> "$INSTALL_SCRIPT_NAME"
        echo "rm -f \"\$SCRIPT_FOLDER/\$SOFTWARE_NAME\".*" >> "$INSTALL_SCRIPT_NAME"
        echo "wget --no-check-certificate --no-cookies --header \"Cookie: oraclelicense=accept-securebackup-cookie\" $URL" >> "$INSTALL_SCRIPT_NAME"

        echo "Downloading \"$REPOSITORY_SOFTWARE_FOLDER/$FILENAME\"..."
        sh "$INSTALL_SCRIPT_NAME"
    fi
fi

finalise

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
REPOSITORY_ARCHIVE=$SCRIPT_FOLDER/repository
REPOSITORY_SOFTWARE_FOLDER=$REPOSITORY_ARCHIVE/$FILENAME
REPOSITORY_SOFTWARE_FOLDER_CUSTOM=$REPOSITORY_ARCHIVE/$2
UTILITY_CREATE_FOLDER=$SCRIPT_FOLDER/create-folder.sh
UTILITY_CLEAN_FILENAME=$SCRIPT_FOLDER/clean-filename.sh
INSTALL_SCRIPT_FILENAME=install.sh
INSTALL_SCRIPT_NAME=$REPOSITORY_SOFTWARE_FOLDER/$INSTALL_SCRIPT_FILENAME
REPOSITORY_SOFTWARE_FILENAME_CLEAN=`echo $REPOSITORY_SOFTWARE_FOLDER/$FILENAME | sed -e 's/%20/ /g' | tr ' ' '_' | tr -d '[{}(),\!]' | tr -d "\'" | sed 's/_-_/_/g'`

if [ -f "$REPOSITORY_SOFTWARE_FILENAME_CLEAN" ]; then
    echo; echo; echo; echo "Software \"$REPOSITORY_SOFTWARE_FILENAME_CLEAN\" already exists."
elif [ -n "$2" ] && [ -d "$REPOSITORY_SOFTWARE_FOLDER_CUSTOM" ]; then
    echo; echo; echo; echo "Software \"$REPOSITORY_SOFTWARE_FOLDER_CUSTOM\" already exists."
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
        #echo "wget --no-check-certificate --no-cookies --header \"Cookie: oraclelicense=accept-securebackup-cookie\" $URL" >> "$INSTALL_SCRIPT_NAME"
        echo "curl --location-trusted --cookie \"oraclelicense=a\" $URL -o \"\$SCRIPT_FOLDER/\$SOFTWARE_NAME\"" >> "$INSTALL_SCRIPT_NAME"
 
        echo; echo; echo; echo "Downloading \"$REPOSITORY_SOFTWARE_FOLDER/$FILENAME\"..."
        sh "$INSTALL_SCRIPT_NAME"
    
        if [ ! -z "$2" ]; then
            if [ -d "$REPOSITORY_SOFTWARE_FOLDER_CUSTOM" ]; then
                rm -R "$REPOSITORY_SOFTWARE_FOLDER_CUSTOM"
            fi

            mv "$REPOSITORY_SOFTWARE_FOLDER" "$REPOSITORY_SOFTWARE_FOLDER_CUSTOM"
            find "$REPOSITORY_SOFTWARE_FOLDER_CUSTOM" -maxdepth 1 -type f | while read -r FILE
            do
                if [ ! "$FILE" = "$INSTALL_SCRIPT_FILENAME" ]; then
                    if [ ! "$FILE" = "$REPOSITORY_SOFTWARE_FOLDER_CUSTOM/$INSTALL_SCRIPT_FILENAME" ]; then
                        echo Renaming the file "$FILE" to "$REPOSITORY_SOFTWARE_FOLDER_CUSTOM/$2"...
                        sudo mv "$FILE" "$REPOSITORY_SOFTWARE_FOLDER_CUSTOM/$2"
                    fi
                fi
            done
        fi
    fi
fi

"$UTILITY_CLEAN_FILENAME" "$REPOSITORY_ARCHIVE"

finalise

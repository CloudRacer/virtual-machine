#!/bin/sh

setScriptFilename() {
	SCRIPT_FILE=`basename $0`
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		echo "ERR: $RESULT: Error encountered while determining the name of the current script."
		return $RESULT;
	fi

	#echo SCRIPT_FILE:$SCRIPT_FILE.

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
	
	#echo SCRIPT_FOLDER:$SCRIPT_FOLDER.
	
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

OPT_FOLDER=/opt
INSTALL_FOLDER=$OPT_FOLDER/hadoop
HADOOP_HOME=$INSTALL_FOLDER/default
HADOOP_VERSION=2.7.2
SOURCE_FILENAME=hadoop-$HADOOP_VERSION.tar.gz
SOFTWARE_DOWNLOAD_URL=http://apache.mirror.anlx.net/hadoop/common/hadoop-$HADOOP_VERSION/$SOURCE_FILENAME
SOFTWARE_FOLDER=$SCRIPT_FOLDER/software/hadoop
HADOOP_BINARY=$SOFTWARE_FOLDER/$SOURCE_FILENAME
HADOOP_USER=hadoop
HADOOP_USER_HOME=/home/$HADOOP_USER
UTILITY_FETCH_FOLDER=$SCRIPT_FOLDER/download.sh
UTILITY_UNPACK_FOLDER=$SCRIPT_FOLDER/unpack.sh
UTILITY_ENV_VAR_CREATE=$SCRIPT_FOLDER/environment-variable-create.sh
UTILITY_ENV_VAR_UPDATE=$SCRIPT_FOLDER/environment-variable-update.sh
ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME=/etc/environment

echo OPT_FOLDER:$OPT_FOLDER.
echo INSTALL_FOLDER:$INSTALL_FOLDER.
echo HADOOP_HOME:$HADOOP_HOME.
echo HADOOP_VERSION:$HADOOP_VERSION.
echo SOURCE_FILENAME:$SOURCE_FILENAME.
echo SOFTWARE_DOWNLOAD_URL:$SOFTWARE_DOWNLOAD_URL.
echo SOFTWARE_FOLDER:$SOFTWARE_FOLDER.
echo HADOOP_BINARY:$HADOOP_BINARY.
echo HADOOP_USER:$HADOOP_USER.
echo HADOOP_USER_HOME:$HADOOP_USER_HOME.
echo UTILITY_FETCH_FOLDER:$UTILITY_FETCH_FOLDER.
echo UTILITY_UNPACK_FOLDER:$UTILITY_UNPACK_FOLDER.
echo UTILITY_ENV_VAR_CREATE:$UTILITY_ENV_VAR_CREATE.
echo UTILITY_ENV_VAR_UPDATE:$UTILITY_ENV_VAR_UPDATE.
echo ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME:$ENVIRONMENT_VALIABLE_SYSTEM_WIDE_FILENAME.

echo
echo
echo

"$UTILITY_FETCH_FOLDER" "$SOFTWARE_DOWNLOAD_URL"
sudo "$UTILITY_UNPACK_FOLDER" "$SOURCE_FILENAME" "$INSTALL_FOLDER"
for file in `ls $INSTALL_FOLDER`; do
    echo "Renaming the \"$INSTALL_FOLDER/$file\" \"$INSTALL_FOLDER/default\"..."
    sudo mv "$INSTALL_FOLDER/$file" "$HADOOP_HOME"
done

echo "Creating the user $HADOOP_USER, with the password of $HADOOP_USER, and a home folder of $HADOOP_USER_HOME..."
sudo useradd -m -d $HADOOP_USER_HOME $HADOOP_USER
sudo passwd $HADOOP_USER <<EOF
$HADOOP_USER
$HADOOP_USER
$HADOOP_USER
EOF

echo "Change the default shell to bash for the user \"$HADOOP_USER\"..."
sudo cp /vagrant/configuration/* $HADOOP_HOME/etc/hadoop

"$UTILITY_ENV_VAR_UPDATE" "PATH" "\"$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin\""
"$UTILITY_ENV_VAR_CREATE" "HADOOP_HOME" "$HADOOP_HOME"
"$UTILITY_ENV_VAR_CREATE" "HADOOP_HOME" "$HADOOP_HOME"
"$UTILITY_ENV_VAR_CREATE" "HADOOP_MAPRED_HOME" "$HADOOP_HOME"
"$UTILITY_ENV_VAR_CREATE" "HADOOP_COMMON_HOME" "$HADOOP_HOME"
"$UTILITY_ENV_VAR_CREATE" "HADOOP_HDFS_HOME" "$HADOOP_HOME"
"$UTILITY_ENV_VAR_CREATE" "YARN_HOME" "$HADOOP_HOME"
"$UTILITY_ENV_VAR_CREATE" "HADOOP_COMMON_LIB_NATIVE_DIR" "$HADOOP_HOME/lib/native"
"$UTILITY_ENV_VAR_CREATE" "HADOOP_INSTALL" "$HADOOP_HOME"
"$UTILITY_ENV_VAR_CREATE" "YARN_LOG_DIR" "/home/$HADOOP_USER/logs/hadoop/yarn"

finalise

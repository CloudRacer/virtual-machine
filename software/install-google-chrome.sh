#!/bin/sh

NEW_ENTRY="deb \[arch=amd64\] http://dl.google.com/linux/chrome/deb/ stable main"
NEW_ENTRY_PLAIN=`echo $NEW_ENTRY| tr -d '\\\\'`
FILENAME="/etc/apt/sources.list.d/google-chrome.list"

if [ -f $FILENAME ]; then
    ENTRY_COUNT=`cat $FILENAME | grep "$NEW_ENTRY" | wc -l`
else
    ENTRY_COUNT=0;
fi

if [ $ENTRY_COUNT -eq 0 ]; then
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
    sudo echo "$NEW_ENTRY_PLAIN" >> "$FILENAME"

    sudo apt-get update 
    sudo apt-get -y install google-chrome-stable
else
    echo "The entry \"$NEW_ENTRY_PLAIN\" already exists in the file \"$FILENAME\"."
fi

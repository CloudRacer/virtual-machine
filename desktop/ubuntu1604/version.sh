#!/bin/sh

. /etc/environment

echo
echo
echo
echo "***** Linux *****"
uname -a
lsb_release -a
echo "******************"

echo
echo
echo
echo "***** Java *****"
java -version
echo "******************"

echo
echo
echo
echo "***** Maven *****"
mvn --version
echo "******************"

echo
echo
echo
echo "***** Git *****"
git --version
echo "******************"

echo
echo
echo
echo "***** npm *****"
npm -v
echo "******************"

echo
echo
echo
echo "***** Bower *****"
bower -v
echo "******************"

#!/bin/bash

XAMPP_PATH=/opt/lampp
BACKUP_PATH=htdocbackup
HTML_DIR=/htdocs
RED='tput setaf 1'
GREEN='tput setaf 2'
RESET='tput sgr0'
OLD_IFS=$IFS
TMP="/"

echo "CHECKING XAMPP.."

if [ -d $XAMPP_PATH ]; then
	echo "XAMPP CHECK $(${GREEN})OK!$(${RESET})"
else
	echo "CAN NOT FIND XAMPP FOLDER."
	echo "Make sure XAMPP is installed and the /opt/lampp folder is present"
	echo "XAMPP CHECK $(${RED})FAILED!$(${RESET})"
	echo "$(${RED})ABORT!$(${RESET})"
	exit 0;
fi;

cd ..

#Apache needs the whole path to be executable by "OTHERS"
#If one of the subpath is not executable by "OTHERS", it will fail
echo "CHECKING IF COMPLETE PATH IS EXECUTABLE BY \"OTHERS\""

CUR_PATH=$(pwd)
IFS='/'
for i in $CUR_PATH
do
        IFS=$OLD_IFS
        if [ "$i" != "" ]; then
                TMP="$TMP$i/"
                PERM=$(stat -c "%a" $TMP)
                if [ $((PERM & 1)) -eq 0 ]; then
                        echo "$TMP $(${RED}) is not executable $(${RESET})"
                        echo "Please move your git repository to another path"
			echo "PATH CHECK $(${RED})FAILED!$(${RESET})"
			echo "$(${RED})ABORT!$(${RESET})"
			exit 0
                fi;
        fi
done

echo "PATH CHECK $(${GREEN})OK!$(${RESET})"

echo "Backing up the original XAMPP htdocs folder..."
if [ -d $XAMPP_PATH$BACKUP_PATH ]; then
	echo "back up folder exists, not backing up..."
else
	cp -r $XAMPP_PATH$HTML_DIR $XAMPP_PATH$BACKUP_PATH
fi;

echo "Removing the original htdoc folder..."
sudo rm -rf $XAMPP_PATH$HTML_DIR
 
echo "Creating htdoc symlink..."
sudo ln -sT $(pwd)$HTML_DIR $XAMPP_PATH$HTML_DIR 

echo "$(${GREEN})Installation Complete!$(${RESET})"

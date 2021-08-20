#!/bin/bash

declare y="n"

#ROOT
if [ $EUID != 0 ];
then
sudo "$0" "$@"
exit $?
fi

mkdir /tmp/$SUDO_USER > a
mkdir /tmp/$SUDO_USER/software > a
mkdir /tmp/$SUDO_USER/software/dme > a
rm /tmp/$SUDO_USER/software/dme/* > a
cp -f dme21.tar.gz /tmp/$SUDO_USER/software/dme/dme21.tar.gz > a
cp -f dme.readme /tmp/$SUDO_USER/software/dme/readme > a
rm a
cd /tmp/$SUDO_USER/software/dme
tar -xf dme21.tar.gz > b
chown $SUDO_USER * > b
chmod 700 * > b
chmod +x * > b
rm b dme21.tar.gz
clear
read -p "Execute? [yn]" y
if [[ $y == "y" ]];
then
./swinst.sh
else
clear
printf "%ssh /home/$SUDO_USER/software/dme/swinst.sh to run\n\n"
fi
exit

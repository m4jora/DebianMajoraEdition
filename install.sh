#!/bin/bash

#ROOT
if [ $EUID != 0 ];
then
sudo "$0" "$@"
exit $?
fi

#DECLARE
declare uzer=$SUDO_USER surewhynot="Nah"

#MAKE files+dirs
#dirs
mkdir /home/$uzer > a
mkdir /home/$uzer/software > b
mkdir /home/$uzer/software/deb-maj > c

#copy files, force
cp -f debmaj_2021.tar.gz /home/$uzer/software/deb-maj/debmaj_2021.tar.gz > d
cp -f readme /home/$uzer/software/deb-maj/readme > e
rm a b c d e

#goto dir, x tar
cd /home/$uzer/software/deb-maj
tar -xf debmaj_2021.tar.gz > b

#change ownership to enable exec
chmod 700 * > c
chmod +x * > d
chown $uzer * > e
chgrp $uzer * > f
rm b c d e f

#NOTIFY
clear 
printf "Install Complete!"
sleep 2

#start?
clear
printf "%sRun the ENTIRE script right now?\n\n"
select surewhynot in Sure Nah
do
case $surewhynot in
Sure)
./swinst.sh
;;
Nah)
exit
;;
*)
exit
;;
'')
exit
;;
esac
done

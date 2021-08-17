#!/bin/bash
#software installer for:
#pen-testing, multimedia and office
#steam, protonvpn, keeperpw
#fonts, 
#8-17-21

#ROOT
if [ $EUID != 0 ];
then
sudo "$0" "$@"
exit $?
fi

#DECLARE
declare uber=$SUDO_USER

#slog #yes #logname
declare s yn l="swinst.log"

#phasename
declare p=("null" "KaliTools" "PlasmaMultimedia" "LibreOffice" "NVidia" "Local" "Qt5" "Fonts" "CleanBenchmark" "UpGrub" "GrandFinale")

#phasenum 
declare -i i=1

#goto file dir
cd /home/$uber/software/deb-maj

#INIT main log
printf "%s\n\nLog Generated on $(date +%D) at $(date +%T):\n\n\n\n" > $l

#FUNCTION mf: 
function mf(){
#INIT slog and temps
s="$l.$i"
printf "" > $s
printf "" > temp1
printf "" > temp2

#first iter cmds
if [ $i -le 1 ];
then
apt update -y |& tee -a temp1
apt upgrade -y |& tee -a temp1
apt -y dist-upgrade |& tee -a temp1
apt install wget -y |& tee -a temp1
fi

#for every arg per section, run cmd and log properly
for (( x = 1 ; x <= $# ; x++ ));
do
clear
printf "%s${p[i]} Phase in motion!\n\n" | tee -a temp1
sleep 1
${!x} |& tee -a temp1
printf "%s\n\nErrors and Warnings:\n\n" >> temp1

#copy temp1 -> temp2[new]
#w e/w -> temp2
cp temp1 temp2
cat temp1 | grep -i 'swinst\|error\|warning\|e:\|w:' >> temp2

#m temp2 to slog[new]
#w slog to mainlog
mv temp2 $s
cat $s >> $l
sleep 1

#cleanup
rm temp1
done



if [ $i == 6 ]
then
rm qt5.5
fi

if [ $i == 3 ]
then
rm libretemp3
fi

#phase increment
((i++))
clear

#prompt for next
read -p "Hit [Return] to start ${p[i]} phase..."

phaser
}

#FUNCTION phaser (holds all commands)
phaser() {
case $i in 
1)
#kali repo and tools
mf "wget https://archive.kali.org/archive-key.asc" "cp archive-key.asc /etc/apt/trusted.gpg.d/kali-asc.asc" "wget -O kali-archive-keyring_2020.2_all.deb https://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2020.2_all.deb" "dpkg -i kali-archive-keyring_2020.2_all.deb" "printf \"%s\n\n#kali-rolling\ndeb http://http.kali.org/kali kali-rolling main non-free contrib\" >> /etc/apt/sources.list" "apt install kali-linux-everything kismet-plugins kismet-doc kismet-capture-uber* kismet-capture* gr-fosphor swig filezilla gpsd festival -y"
;;
2)
#qml plasma multimedia custom #remove gmail feed
mf "apt install qml* qml *qml* *qml plasma* *plasma* python3-pyside2.qtmultimedi* fp-units-multimedi* kdemultimedia -y" "apt install multimedia-all -y" "apt install clementine synaptic aptitud* ktorren* brasero thunderbird firefox-developer* kshutdown ykcs11 ykls ykush-control python3-ykman libyk* libgl1-nvidia-glvnd-glx:i386 cairo-dock-* cairo-dock kirigami-gallery edac-utils libedac1 scdaemon memtest86 binutils-x86* cantor-backend* python3-pip python3-pyqt5 apt-transport-https curl gnupg2 software-properties-common system-tools-backends docker debconf-kde-* gkdebconf kde-config* kde-zeroconf kdenliv* kdesignerplugin kdesvn kdev* libreoffice-kde5 libdebconf-kde1 nautilus-kdeconnect xsettings-kde oxygencursors xfonts* appstream-generator appstream-util gir1.2-appstream* libappstream-compose0 protonvpn -y" "apt remove plasma-gmailfeed gmail* *gmail *gmail* -y"
;;
3)
#libreoffice
apt list | grep 'libreoffice' | grep -v 'i386\|nogui\|dev\|libreoffice-l10n-\|libreoffice-help-' | sed 's/\/.*//' > libretemp1
sed ':a;N;$!ba;s/\n/ /g' libretemp1 > libretemp2
sed 's/^/apt install \-y libreoffice-help-en-us libreoffice-lightproof-en /' libretemp2 > libretemp3
rm libretemp{1,2}
mf "$(cat libretemp3)" "apt install ant-doc antlr javacc junit4 jython libbcel-java libbsf-java libcommons-net-java libjaxp1.3-java libjdepend-java libjsch-java liboro-java libregexp-java libxalan2-java firebird3.0-server firebird3.0-doc libaopalliance-java-doc libapache-poi-java-doc libbcmail-java-doc libbcpkix-java-doc libbcprov-java-doc libcommons-collections3-java-doc libcommons-collections4-java-doc libdom4j-java-doc libmsv-java libxpp2-java libflute-java-doc libfonts-java-doc libformula-java-doc libasm-java libcglib-java libjetbrains-annotations-java-doc libjcommon-java-doc libjdom1-java-doc libjsoup-java-doc liblog4j1.2-java-doc libmail-java-doc libmaven-file-management-java-doc libmaven-shared-io-java-doc libmaven-shared-utils-java-doc liblogback-java libjfreereport-java-doc libplexus-classworlds-java-doc libplexus-sec-dispatcher-java-doc libplexus-utils2-java-doc gpa libreoffice-librelogo libreoffice unixodbc libofficebean-java libjtds-java libsqliteodbc tdsodbc odbc-mdbtools mediawiki librepository-java-doc libsac-java-doc testng libxerces2-java-doc libxml-commons-resolver1.1-java-doc libxom-java-doc libreoffice -y"
;;
4)
#nvidia driver, tools, cl, mesa
mf "apt install nvidia-driver nvidia-cuda-toolkit hashcat-nvidia clinfo -y" "apt remove mesa-opencl-icd -y" "apt install mesa-utils -y"
;;
5)
#local
mf "dpkg -i protonvpn-stable-release_1.0.1-1_all.deb" "wget https://www.keepersecurity.com/desktop_electron/Linux/repo/deb/keeperpasswordmanager_16.1.1_amd64.deb" "dpkg -i keeperpasswordmanager_16.1.1_amd64.deb" "dpkg -i steam_latest.deb" "apt update -y" "apt remove steam -y" "apt install steam steam-launcher zenity zenity-common -y"
;;
6)
#qt5
apt list | grep 'qt5' | grep -v 'installed\|gles' > qt5.1
sed 's/\/.*//' qt5.1 > qt5.2
sed ':a;N;$!ba;s/\n/ /g' qt5.2 > qt5.3
sed 's/^/apt install \-y /' qt5.3 > qt5.4
sed 's/phonon4qt5-backend-null //' qt5.4 > qt5.5
rm qt5.{1,2,3,4}
mf "$(cat qt5.5)"
;;
7)
#fonts
mf "apt install xfonts* tv-fonts trufont toilet-fonts thunar-font-manager texlive-font* r-cran-systemfonts r-cran-fontquiver r-cran-fontbitstreamvera python3*font* python-font* node-ansi-font nautilus-font-manager lilypond-fonts latex-fonts* konfont hershey-font* gsfont* gnome-font-viewer fonty-rg fonttools fonts-* fontmatrix fontmanager.app fontc* font-* emacs-intl-fonts elpa-clojure-mode-extra-font-locking cmatrix-xfont cube2font braillefont birdfont -y"
;;
8)
#wrapup
clear
printf "Choose Plasma."
sleep 2
#config xserver
update-alternatives --config x-session-manager
#benchmark gpu
hashcat -b | uniq
#purge
mf "apt autoremove -y"
;;
9)
#update grub and reboot
mf "update-grub"
sleep 1
clear
read -p "Done! You should probably reboot."
exit
;;
esac
}
phaser

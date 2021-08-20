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
declare s l="swinst.log"

#phasename
declare p=("null" "KaliTools" "PlasmaMultimedia" "LibreOffice" "NVidia" "Local" "Qt5" "Fonts" "CleanBenchmarkUpGrub" "GrandFinale")

#phasenum 
declare -i i=1

#goto file dir
cd /tmp/$uber/software/dme

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
${!x} |& tee -a temp1

#copy temp1 -> temp2[new]
#w e/w -> temp2
cat temp1 >> temp2
printf "%s\n\nErrors and Warnings:\n\n" >> temp2
cat temp1 | grep -i 'swinst\|error\|warning\|e:\|w:' >> temp2

#m temp2 to slog[new]
#w slog to mainlog


#cleanup
rm temp1
done

#phase increment
((i++))
clear
cat temp2 > $s
printf "" > temp2
cat $s >> $l

phaser
}

#FUNCTION phaser (holds all commands)
phaser() {
case $i in 
1)
#kali repo and tools
printf "%s#debian\ndeb http://deb.debian.org/debian/ bullseye main non-free contrib\n\n#debian sec\ndeb http://security.debian.org/debian-security bullseye-security main contrib non-free\n\n#debian updates\ndeb http://deb.debian.org/debian/ bullseye-updates main contrib non-free\n\n#kali rolling\ndeb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list

mf "wget https://archive.kali.org/archive-key.asc" "wget -O kali-archive-keyring_2020.2_all.deb https://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2020.2_all.deb" "mv -f archive-key.asc /etc/apt/trusted.gpg.d/kali-asc.asc" "apt update -y" "apt upgrade -y" "apt -y dist-upgrade" "dpkg -i kali-archive-keyring_2020.2_all.deb" "apt update -y" "apt install kali-linux-everything kismet-plugins kismet-doc kismet-capture-uber* kismet-capture* gr-fosphor swig filezilla gpsd festival curl -y"
;;
2)
#qml plasma multimedia forensics custom #remove gmail feed
apt list | grep '^foren' | sed 's/\/.*//' > foren1
sed ':a;N;$!ba;s/\n/ /g' foren1 > foren2

mf "apt install $(cat foren2) -y" "apt install qml* qml *qml* *qml plasma* *plasma* python3-pyside2.qtmultimedi* fp-units-multimedi* kdemultimedia multimedia-all clementine synaptic aptitud* ktorren* brasero thunderbird firefox-developer* kshutdown ykcs11 ykls ykush-control python3-ykman libyk* libgl1-nvidia-glvnd-glx cairo-dock-* cairo-dock kirigami-gallery edac-utils libedac1 scdaemon memtest86 binutils-x86* cantor-backend* python3-pip python3-pyqt5 apt-transport-https gnupg2 software-properties-common system-tools-backends docker debconf-kde-* gkdebconf kde-config* kde-zeroconf kdenliv* kdesignerplugin kdesvn kdev* libreoffice-kde5 libdebconf-kde1 nautilus-kdeconnect xsettings-kde oxygencursors xfonts* appstream-generator appstream-util gir1.2-appstream* libappstream-compose0 torbrowser-launcher tor torsocks -y" "apt remove plasma-gmailfeed libnet-gmail-imap-label-perl gnome-gmail -y"
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
#local (steam protonvpn keeper)
printf "%s#steam\ndeb [arch=amd64,i386] http://repo.steampowered.com/steam/ stable steam" > /etc/apt/sources.list.d/steam.list

mf "apt update -y" "apt upgrade -y" "wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb" "wget https://repo.steampowered.com/steam/archive/stable/steam.gpg" "wget https://protonvpn.com/download/protonvpn-stable-release_1.0.1-1_all.deb" "wget https://www.keepersecurity.com/desktop_electron/Linux/repo/deb/keeperpasswordmanager_16.1.1_amd64.deb" "mv -f steam.gpg /etc/apt/trusted.gpg.d/steam.gpg" "dpkg -i steam_latest.deb" "apt-get update -y" "apt-get upgrade -y" "apt install libgl1-mesa-dri:amd64 libgl1-mesa-dri:i386 libgl1-mesa-glx:amd64 libgl1-mesa-glx:i386 libgl-gst:i386 libgl1-nvidia-glvnd-glx:i386 libgl1:i386 libgl2ps1.4:i386 libglade2-0:i386 libglademm-2.4-1v5:i386 libgladeui-2-13:i386 libglapi-mesa:i386 libglbinding2:i386 libglbsp3:i386 libglc0:i386 libgle3:i386 libgles-nvidia1:i386 libgles-nvidia2:i386 libgles1:i386 libgles2-mesa:i386 libgles2:i386 libglew2.1:i386 libglewmx1.13:i386 libglfw3:i386 libglib2.0-0:i386 libglib2.0-bin:i386 libglibd-2.0-0:i386 libglibmm-2.4-1v5:i386 libglide3:i386 libglobjects1:i386 libglom-1.30-0:i386 libgloox18:i386 libglpk-java:i386 libglpk40:i386 libgltf-0.1-1:i386 libglu1-mesa:i386 libgluegen2-jni:i386 libglusterd0:i386 libglusterfs0:i386 libglvnd0:i386 libglw1-mesa:i386 libglx-mesa0:i386 libglx-nvidia0:i386 libglx0:i386 libglyr1:i386 libnvidia-allocator1:i386 libnvidia-compiler:i386 libnvidia-eglcore:i386 libnvidia-encode1:i386 libnvidia-fbc1:i386 libnvidia-glcore:i386 libnvidia-glvkspirv:i386 libnvidia-ifr1:i386 libnvidia-ml1:i386 libnvidia-opticalflow1:i386 libnvidia-ptxjitcompiler1:i386 steam-launcher zenity zenity-common abigail-tools:i386 libabigail0:amd64 libabigail0:i386 libgail-3-0:amd64 libgail-3-0:i386 libgail-common:amd64 libgail-common:i386 libgail18:amd64 libgail18:i386 -y" "dpkg -i protonvpn-stable-release_1.0.1-1_all.deb" "apt update -y" "apt upgrade -y" "apt install protonvpn-cli protonvpn-gui protonvpn-stable-release protonvpn python3-proton-client python3-protonvpn-nm-lib python3-qpid-proton -y" "apt install gnome-shell-extension-appindicator -y" "apt update -y" "apt upgrade -y" "dpkg -i keeperpasswordmanager_16.1.1_amd64.deb" "apt update -y" "apt upgrade -y" "apt install keeperpasswordmanager -y" "apt update -y" "apt upgrade -y"
;;
6)
#qt5
apt list | grep 'qt5' | grep -v 'gles' > qt5.1
sed 's/\/.*//' qt5.1 > qt5.2
cat qt5.2 | grep -v 'phonon4qt5-backend-null' qt5.2 > qt5.3
sed ':a;N;$!ba;s/\n/ /g' qt5.3 > qt5.4
sed 's/^/apt install \-y /' qt5.4 > qt5.5
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
sleep 1
#config xserver
update-alternatives --config x-session-manager
#purge
mf "apt autoremove -y" "rm qt5.5 libretemp3" "update-grub"
;;
9)
#benchmark gpu
rm temp2 foren1 foren2
declare ben="n"
read -p "Benchmark GPU? [yn]" ben
if [[ $ben == "y" ]];
then
hashcat -b | uniq | tee nvidia.benchmark
clear
printf "Benchmark complete!"
sleep 1
fi
clear
read -p "Hit [Return] to reboot..."
systemctl reboot
exit
;;
esac
}
phaser

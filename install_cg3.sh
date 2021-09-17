#!/bin/bash

if [[ `whoami` != root ]]
then
	echo "You must run this Apertium install script as root, or via sudo!"
	exit -1
fi

CADENCE=nightly

if [[ -x "$(which curl)" ]]; then
	GET="curl -sS"
elif [[ -x "$(which wget)" ]]; then
	GET="wget -nv -O -"
else
	echo "Neither curl nor wget found - need one of them!"
	exit -1
fi

echo "Cleaning up old install, if any..."
rm -fv /etc/apt/trusted.gpg.d/apertium* /etc/apt/preferences.d/apertium* /etc/apt/sources.list.d/apertium*

echo "Determining Debian/Ubuntu codename..."

os_codename_file=$(cat /etc/os-release)
regex_for_codename="VERSION_CODENAME=([a-zA-Z]+)"
DISTRO=""
if [[ $os_codename_file =~ $regex_for_codename ]]
then
    DISTRO="${BASH_REMATCH[1]}"
else
    echo "Cannot find the code name of the operating system"
    exit -1
fi

if [[ $DISTRO == "kali-rolling" ]]
then
	DISTRO=bullseye
	echo "Assuming kali-rolling = $DISTRO"
fi

echo "Settling for $DISTRO - enabling the Apertium $CADENCE repo..."

echo "Installing Apertium GnuPG key to /etc/apt/trusted.gpg.d/apertium.gpg"
$GET https://apertium.projectjj.com/apt/apertium-packaging.public.gpg >/etc/apt/trusted.gpg.d/apertium.gpg

echo "Installing package override to /etc/apt/preferences.d/apertium.pref"
$GET https://apertium.projectjj.com/apt/apertium.pref >/etc/apt/preferences.d/apertium.pref

echo "Creating /etc/apt/sources.list.d/apertium.list"
echo "deb http://apertium.projectjj.com/apt/$CADENCE $DISTRO main" > /etc/apt/sources.list.d/apertium.list

echo "Running apt-get update..."
apt-get -qy update >/dev/null 2>&1

echo "All done - enjoy the packages! If you just want all core tools, do: sudo apt-get install apertium-all-dev"
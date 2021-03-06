#!/bin/bash
# based on https://raw.githubusercontent.com/Homegear/Homegear-Docker/master/nightly/installNightly.sh

if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

SCRIPTDIR="$( cd "$(dirname $0)" && pwd )"

apt-get update
system="debian_buster"
machine=$(uname -m)
echo "Machine: $machine"
if [[ $machine == "x86_64" ]]; then
	arch="amd64"
elif [[ $machine == "aarch64" ]]; then
	arch="arm64"
elif [[ $machine == "armv7l" ]]; then
	arch="armhf"
else
	echo "Unknown architecture"
	exit 1
fi
echo "Architecture: $arch"

function downloadModule {
	wget https://homegear.eu/downloads/nightlies/${1} || exit 1
}

function installModule {
	dpkg -i ${1}
	if [ $? -ne 0 ]; then
		apt-get -y -f install || exit 1
		dpkg -i ${1} || exit 1
	fi
}

TEMPDIR=$(mktemp -d)
cd $TEMPDIR
rm -f homegear*.deb
rm -f libhomegear*.deb

wget https://homegear.eu/downloads/nightlies/libhomegear-base_current_${system}_${arch}.deb || exit 1
wget https://homegear.eu/downloads/nightlies/libhomegear-node_current_${system}_${arch}.deb || exit 1
wget https://homegear.eu/downloads/nightlies/libhomegear-ipc_current_${system}_${arch}.deb || exit 1
wget https://homegear.eu/downloads/nightlies/python3-homegear_current_${system}_${arch}.deb || exit 1
wget https://homegear.eu/downloads/nightlies/homegear_current_${system}_${arch}.deb || exit 1
wget https://homegear.eu/downloads/nightlies/homegear-nodes-core_current_${system}_${arch}.deb || exit 1
wget https://homegear.eu/downloads/nightlies/homegear-nodes-extra_current_${system}_${arch}.deb || exit 1
wget https://homegear.eu/downloads/nightlies/homegear-licensing_current_${system}_${arch}.deb || exit 1
wget https://homegear.eu/downloads/nightlies/homegear-easy-licensing_current_${system}_${arch}.deb || exit 1

downloadModule homegear-max_current_${system}_${arch}.deb

downloadModule homegear-influxdb_current_${system}_${arch}.deb
downloadModule homegear-management_current_${system}_${arch}.deb
downloadModule homegear-webssh_current_${system}_${arch}.deb
downloadModule homegear-adminui_current_${system}_${arch}.deb
downloadModule homegear-ui_current_${system}_${arch}.deb

dpkg -i libhomegear-base_current_${system}_${arch}.deb
if [ $? -ne 0 ]; then
	apt-get -y -f install || exit 1
	dpkg -i libhomegear-base_current_${system}_${arch}.deb || exit 1
fi

dpkg -i libhomegear-node_current_${system}_${arch}.deb
if [ $? -ne 0 ]; then
	apt-get -y -f install || exit 1
	dpkg -i libhomegear-node_current_${system}_${arch}.deb || exit 1
fi

dpkg -i libhomegear-ipc_current_${system}_${arch}.deb
if [ $? -ne 0 ]; then
	apt-get -y -f install || exit 1
	dpkg -i libhomegear-ipc_current_${system}_${arch}.deb || exit 1
fi

dpkg -i python3-homegear_current_${system}_${arch}.deb
if [ $? -ne 0 ]; then
	apt-get -y -f install || exit 1
	dpkg -i python3-homegear_current_${system}_${arch}.deb || exit 1
fi

dpkg -i homegear_current_${system}_${arch}.deb
if [ $? -ne 0 ]; then
	apt-get -y -f install || exit 1
	dpkg -i homegear_current_${system}_${arch}.deb
	if [ $? -ne 0 ]; then
		apt-get -y -f install || exit 1
		dpkg -i homegear_current_${system}_${arch}.deb || exit 1
	fi
fi

dpkg -i homegear-nodes-core_current_${system}_${arch}.deb
if [ $? -ne 0 ]; then
	apt-get -y -f install || exit 1
	dpkg -i homegear-nodes-core_current_${system}_${arch}.deb || exit 1
fi

dpkg -i homegear-nodes-extra_current_${system}_${arch}.deb
if [ $? -ne 0 ]; then
	apt-get -y -f install || exit 1
	dpkg -i homegear-nodes-extra_current_${system}_${arch}.deb || exit 1
fi

dpkg -i homegear-licensing_current_${system}_${arch}.deb
if [ $? -ne 0 ]; then
	apt-get -y -f install || exit 1
	dpkg -i homegear-licensing_current_${system}_${arch}.deb || exit 1
fi

dpkg -i homegear-easy-licensing_current_${system}_${arch}.deb
if [ $? -ne 0 ]; then
	apt-get -y -f install || exit 1
	dpkg -i homegear-easy-licensing_current_${system}_${arch}.deb || exit 1
fi

installModule homegear-max_current_${system}_${arch}.deb

installModule homegear-influxdb_current_${system}_${arch}.deb
installModule homegear-management_current_${system}_${arch}.deb
installModule homegear-webssh_current_${system}_${arch}.deb
installModule homegear-adminui_current_${system}_${arch}.deb
installModule homegear-ui_current_${system}_${arch}.deb

rm -f /etc/homegear/dh1024.pem
rm -f /etc/homegear/homegear.key
rm -f /etc/homegear/homegear.crt

cd $SCRIPTDIR
rm -Rf $TEMPDIR
rm -f /InstallNightly.sh

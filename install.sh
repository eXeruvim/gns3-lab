#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
echo "This script must be run as root" >&2
exit 1
fi

# Update system
dnf -y update

# Install dynamips dependencies
dnf -y install gcc cmake elfutils-libelf-devel libuuid-devel libpcap-devel

# Clone and install dynamips
git clone https://github.com/GNS3/dynamips.git
cd dynamips
mkdir build
cd build
cmake ..
make
cd ../..

# Install iouyap dependencies and iniparser
dnf -y install git bison flex
cd /tmp
git clone http://github.com/ndevilla/iniparser.git
cd iniparser
make
cp libiniparser.* /usr/lib/
cp src/iniparser.h /usr/local/include
cp src/dictionary.h /usr/local/include
cd ..

# Clone and install iouyap
git clone https://github.com/GNS3/iouyap.git
cd iouyap
make
make install
cd ..

# Install GNS3 server dependencies and GNS3 server via pip
dnf -y install python3-devel redhat-rpm-config
pip3 install gns3-server

# Install GNS3 GUI dependencies and GNS3 GUI via pip
dnf -y install python3-qt5 python3-sip
pip3 install gns3-gui

# Install VPCS dependencies
dnf -y install glibc-static xterm

# Clone and build VPCS
cd /opt/
git clone https://github.com/GNS3/vpcs.git
cd vpcs/src
sh mk.sh
chmod +rx -R /opt/vpcs

# Install kitty terminal emulator
dnf -y install kitty

# Completion message
echo "**************************************"
echo "Install directory: /opt/vpcs/src"
echo "Please, define it in your GNS3-GUI"
echo "**************************************"

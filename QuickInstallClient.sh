#!/bin/bash
# Basic installation script for Snoopy NG requirements
# glenn@sensepost.com // @glennzw
# Todo: Make this an egg.
set -e

# In case this is the seconds time user runs setup, remove prior symlinks:
rm -f /usr/bin/sslstrip_snoopy
rm -f /usr/bin/snoopy
rm -f /usr/bin/snoopy_auth
rm -f /etc/transforms

apt-get install ntpdate --force-yes --yes
#if ps aux | grep ntp | grep -qv grep; then 
if [ -f /etc/init.d/ntp ]; then
	/etc/init.d/ntp stop
 
	# Needed for Kali Linux build on Raspberry Pi
sudo apt-get install ntp
	/etc/init.d/ntp stop
  
echo "[+] Setting time with ntp"
ntpdate ntp.ubuntu.com 
/etc/init.d/ntp start

echo "[+] Setting timzeone..."
echo "Etc/UTC" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
echo "[+] Installing sakis3g..."
cp ./includes/sakis3g /usr/local/bin

echo "[+] Updating repository..."
apt-get -y update

# Packages
echo "[+] Installing required packages..."
apt-get install --force-yes --yes python-setuptools autossh python-psutil python2.7-dev libpcap0.8-dev ppp tcpdump python-serial sqlite3 python-requests iw build-essential python-bluez python-flask python-gps python-dateutil python-dev libxml2-dev libxslt-dev pyrit mitmproxy

# Python packages

easy_install pip
easy_install smspdu

echo "[+] Installing Python Packages 1/9"
pip install sqlalchemy==0.7.4
echo "[+] Installing Python Packages 2/9"
pip uninstall requests -y
echo "[+] Installing Python Packages 3/9"
pip install -Iv https://pypi.python.org/packages/source/r/requests/requests-0.14.2.tar.gz   #Wigle API built on old version
echo "[+] Installing Python Packages 4/9"
pip install httplib2
echo "[+] Installing Python Packages 5/9"

pip install BeautifulSoup
echo "[+] Installing Python Packages 6/9"
pip install publicsuffix
echo "[+] Installing Python Packages 7/9"
#pip install mitmproxy
pip install pyinotify
echo "[+] Installing Python Packages 8/9"
pip install netifaces
echo "[+] Installing Python Packages 9/9"
pip install dnslib

#Install SP sslstrip
echo "[+] Installing SSLStrip"
cp -r ./setup/sslstripSnoopy/ /usr/share/
ln -s /usr/share/sslstripSnoopy/sslstrip.py /usr/bin/sslstrip_snoopy

# Download & Installs
echo "[+] Installing pyserial 2.6"
pip install https://pypi.python.org/packages/source/p/pyserial/pyserial-2.6.tar.gz

echo "[+] Downloading pylibpcap..."
sudo apt-get -y install python-libpcap

echo "[+] Downloading dpkt..."
pip install dpkt

echo "[+] Installing patched version of scapy..."
pip install ./setup/scapy-latest-snoopy_patch.tar.gz

    echo "[+] Installing dependencies 1/2"
    
    sudo apt-get -y install libssl1.0-dev
 sudo apt-get -y install libnl1
sudo apt-get -y install libnl-dev
sudo apt-get -y install libnl-3-dev
echo "[+] Installing dependencies 2/2"
sudo apt-get -y install libnl-genl-3-dev
sudo apt-get -y install libssl-dev
sduo apt-get -y install ethtool

echo "[+] Downloading aircrack-ng..."
    wget http://download.aircrack-ng.org/aircrack-ng-1.2-beta1.tar.gz
    tar xzf aircrack-ng-1.2-beta1.tar.gz
    cd aircrack-ng-1.2-beta1
    
  echo "[+] Installing Aircrack-ng 1/2"
    sudo make
    echo "[-] Installing Aircrack-ng 2/2"
    sudo make install
    cd ..
   rm -rf aircrack-ng-1.2-beta1*

echo "[+] Creating symlinks to this folder for snoopy.py."

echo "sqlite:///`pwd`/snoopy.db" > ./transforms/db_path.conf

ln -s `pwd`/transforms /etc/transforms
ln -s `pwd`/snoopy.py /usr/bin/snoopy
ln -s `pwd`/includes/auth_handler.py /usr/bin/snoopy_auth
chmod +x /usr/bin/snoopy
chmod +x /usr/bin/snoopy_auth
chmod +x /usr/bin/sslstrip_snoopy

echo "[+] Done. Try run 'snoopy' or 'snoopy_auth'"
echo "[I] Ensure you set your ./transforms/db_path.conf path correctly when using Maltego"

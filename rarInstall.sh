#!/bin/bash
# shell script to install rar

install_ver="rarlinux-4.0.1"
prefix=".tar.gz"

if [ -s $install_ver$prefix ]; then
  echo "$install_ver$prefix [found]"
else
  echo "Error: $install_ver$prefix not found!!!download now......"
  wget http://www.rarsoft.com/rar/$install_ver$prefix
fi
tar -zxvf rarlinux-4.0.1.tar.gz
cd rar 
make

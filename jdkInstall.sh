#!/bin/bash
# shell script to install jdk
 
 
# Check if user is root
 
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install JDK"
    exit 1
fi
 
clear
 
cur_dir=$(pwd)
sys_bit=$(getconf LONG_BIT)
#software version default value
jdk_pre="7u75-b13/"
jdk_version="jdk-7u75-linux"
install_version="8"
jdk_url="jdk1.7.0_75"
java_path="/usr/java"
 
 
#Get system bit version
case "$sys_bit" in
64)
sys_bit="x64"
;;
32)
sys_bit="i586"
;;
*)
echo "We don't know your system bit version,We think it's about x86 bit system"
sys_bit="i586"
esac
 
 
#which JDK version do you want to install?
echo "========================================="
echo "which JDK version do you want to install?"
echo "Install JDK 1.7,Please input 7 or press Enter"
echo "Install JDK 1.8,Please input 8"
read -p "(Please input 7 or 8 for jdk,9 for maven3):" install_version
 
case "$install_version" in
7)
echo "You will install JDK 1.7(7u75_$sys_bit)"
jdk_pre="7u75-b13/"
jdk_version="jdk-jdk-7u75-linux"
jdk_url="jdk1.7.0_75"
;;
8)
echo "You will install JDK 1.8(8u102_$sys_bit)"
jdk_pre="8u102-b14/"
jdk_version="jdk-8u102-linux"
jdk_url="jdk1.8.0_102"
;;
9)
echo "You will install maven3"
jdk_pre="8u102-b14/"
jdk_version="jdk-8u102-linux"
jdk_url="jdk1.8.0_102"
;;
*)
echo "INPUT error,You will install JDK 1.7(7u75_$sys_bit)"
jdk_version="7u75-linux"
esac
 
 
# 1. remove openjdk if exists.
for i in $(rpm -qa | grep openjdk | grep -v grep)
do
  echo "Deleting rpm -> "$i
  rpm -e --nodeps $i
done
 
 
function downloadJDK(){
 
if [ -s $jdk_version-$sys_bit.tar.gz ]; then
  echo "$jdk_version-$sys_bit.tar.gz [found]"
  else
  echo "Error: $jdk_version-$sys_bit.tar.gz not found!!!download now......"
  wget --no-check-certificate --no-cookie --header "Cookie:gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie;" http://download.oracle.com/otn-pub/java/jdk/$jdk_pre$jdk_version-$sys_bit.tar.gz
fi
#wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" 
#7x32 http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-i586.rpm
#7x64 http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.rpm
#7x32 http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-i586.tar.gz
#7x64 http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.tar.gz
#8x64 http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.tar.gz
#8x32 http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-i586.tar.gz
#8x64 http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.rpm
#8x32 http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-i586.rpm
 
}
 
 
function installJDK(){
# 1.unzip and install JDK
   
if [ -s $jdk_version-$sys_bit.tar.gz ]; then
  mkdir $java_path
  tar -zxvf $jdk_version-$sys_bit.tar.gz -C $java_path
   
 
 
  # 2. config /etc/profile
 
 
  echo -e "export JAVA_HOME=/usr/java/$jdk_url" >>/etc/profile
  echo -e 'export JRE_HOME=$JAVA_HOME/jre' >>/etc/profile
  echo -e 'export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar'>>/etc/profile
  echo -e 'export PATH=$PATH:$JAVA_HOME/bin'>>/etc/profile
  source /etc/profile 
fi
}
 
 
 
 
 
if [[ ! -z $(rpm -qa | grep openjdk | grep -v grep) ]];
then
  echo "-->Failed to remove the defult JDK."
else
 
 case "$install_version" in
7|8)
# 2. download JDK
# . install JDK
if [ ! -d $java_path ]; then
  downloadJDK  2>&1 | tee -a /root/jdk-install.log && installJDK  2>&1 | tee -a /root/jdk-install.log
else 
  echo "java path exists"
fi
;;
 esac
fi

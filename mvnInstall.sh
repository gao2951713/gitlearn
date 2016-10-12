#!/bin/bash
# shell script to install Maven
basepath="/usr/java/"
mvn_ver="3.3.9"
install_ver="apache-maven-"$mvn_ver
mavenpath='/usr/java/'$install_ver
prefix='bin.tar.gz'

if [  -e $mavenpath  ] ; then
rm -rf $mavenpath
echo "存在maven，移除完毕"
fi


 
function downloadMVN(){
 
	if [ -s $install_ver-$prefix ]; then
	  echo "$install_ver-$prefix [found]"
	else
	  echo "Error: $jdk_version-$sys_bit.tar.gz not found!!!download now......"
	  wget http://apache.fayea.com/maven/maven-3/$mvn_ver/binaries/$install_ver-$prefix
	fi
}

function installMVN(){
	#解压maven到指定文件夹下
	tar -zxvf $install_ver-$prefix -C $basepath
	echo -e 'export MAVEN_HOME='$mavenpath >>/etc/profile
	echo -e 'export CLASSPATH=$CLASSPATH:$MAVEN_HOME/lib'>> /etc/profile
	echo -e 'export PATH=$PATH:$MAVEN_HOME/bin'>> /etc/profile
    source /etc/profile
}

if [ ! -d $mavenpath ]; then
  downloadMVN  2>&1 | tee -a /root/maven-install.log && installMVN  2>&1 | tee -a /root/maven-install.log
else 
  echo "maven path exists"
fi
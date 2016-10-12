#!/bin/bash
# shell script to install jira
basepath="/opt/"
tomcat_ver="9.0.0.M9"
install_ver="apache-tomcat-$tomcat_ver"
tomcatpath='/opt/'$install_ver
prefix='.tar.gz'
adduser='<role rolename="manager"/>     
  <role rolename="admin"/> 
  <role rolename="admin-gui"/>
  <role rolename="manager-gui"/>
  <user username="xxx" password="***" roles="admin-gui,manager-gui"/>'

if [  -e $tomcatpath  ] ; then
rm -rf $tomcatpath
echo "存在tomcat，移除完毕"
fi


 
function downloadTomcat(){
 
	if [ -s $install_ver$prefix ]; then
	  echo "$install_ver$prefix [found]"
	else
	  echo "Error: $install_ver$prefix not found!!!download now......"
	  wget http://apache.fayea.com/tomcat/tomcat-9/v$tomcat_ver/bin/$install_ver$prefix
	fi
}

function installTomcat(){
	#解压maven到指定文件夹下
	tar -zxvf $install_ver$prefix -C $basepath
	#先看下8081端口是否被占用 
	lsof -i:8080
	# edit port 8080 to 8081 of server.xml
	#more $jirapath/conf/server.xml |grep 8080
	#sed -i -e 's|"0:1"|"0:1|\d+\.\d+\.\d+\.\d+"|' $tomcatpath/webapps/manager/META-INF/context.xml
	#sed -i -e 's|8005|8015|' $jirapath/conf/server.xml
}

# if not exists do it.then skip
if [ ! -d $tomcatpath ]; then
  downloadTomcat  2>&1 | tee -a /root/tomcat-install.log && installTomcat  2>&1 | tee -a /root/tomcat-install.log
else 
  echo "tomcat path exists,please remove it"
fi

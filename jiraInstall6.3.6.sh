#!/bin/bash
# shell script to install jira
basepath="/opt/"
jira_ver="6.3.6"
install_ver="atlassian-jira-"$jira_ver
jirapath='/opt/'$install_ver-standalone
prefix='.tar.gz'

if [  -e $jirapath  ] ; then
rm -rf $jirapath
echo "存在jira，移除完毕"
fi


 
function downloadJira(){
 
	if [ -s $install_ver$prefix ]; then
	  echo "$install_ver$prefix [found]"
	else
	  echo "Error: $install_ver$prefix not found!!!download now......"
	  wget http://www.atlassian.com/software/jira/downloads/binary/$install_ver$prefix
	fi
}

function installJira(){
	#解压maven到指定文件夹下
	tar -zxvf $install_ver$prefix -C $basepath
	#先看下8081端口是否被占用 
	lsof -i:8081
	# edit port 8080 to 8081 of server.xml
	more $jirapath/conf/server.xml |grep 8080
	sed -i -e 's|8080|8081|' $jirapath/conf/server.xml
	sed -i -e 's|8005|8015|' $jirapath/conf/server.xml
	more $jirapath/conf/server.xml |grep 8081
	# 配置jira_home 
	sed -i -e 's|jira.home =|jira.home ='$basepath'jira_home|' $jirapath/atlassian-jira/WEB-INF/classes/jira-application.properties
}

# if not exists do it.then skip
if [ ! -d $jirapath ]; then
  downloadJira  2>&1 | tee -a /root/jira-install.log && installJira  2>&1 | tee -a /root/jira-install.log
else 
  echo "jira path exists,please remove it"
fi

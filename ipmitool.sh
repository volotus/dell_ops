#!/bin/bash
#测试要求如下：
# 1，所有的命令都通过ipmitool命令实现
# 2，所有命令都在没有操作系统的情况下测试
 
 
HOST=$1
USER=$2
PASSWD=$3
 
function getinfo()
{
	# 1. 获取到服务器的网络配置信息
	echo -e "\n\n=======Networking Configurations:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD lan print
	# 2.获取到服务器的温度信息
	echo -e "\n\n=======Ambient Temprature:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sdr get "Ambient Temp"
	# 3.获取到服务器的功率信息
	echo -e "\n\n=======System Level:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sdr get "System Level"
	
	# 4.获取到服务器的序列号信息
	echo -e "\n\n=======Serial Number(Fru):"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD fru
	# 5.获取到服务器的MAC
	echo -e "\n\n=======Mac Address(only Dell):"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD delloem mac
	
	# 6.获取到服务器的资产号信息
	echo -e "\n\n=======Serial Number(Fru):"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sdr get "System Level"
 
	# 7.获取到服务器的管理卡的时间
	echo -e "\n\n=======Date and Time:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sel time get
	# 8.查看管理卡配置模式
	echo -e "\n\n=======Lan set Mode:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD delloem lan get
	# 9.查看SOL波特率
	echo -e "\n\n=======Volatile Bit Rate (kbps):"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sol info 1
}
 
function operation()
{
	# 1.服务器开机、关机、重启
	echo -e "\n\n=======Power:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD power
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD power status
	
	# 2.服务器添加用户、设置密码、授予权限
	echo -e "\n\n=======USER:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD user list 1
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD user set name 10 test1
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD user set password 10 test1pwd
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD user enable 10
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD user list 1
	# 1-CALLBACK ,2-USER ,3-OPERATOR ,4-ADMNISTRATOR
	echo -e "\n\n=======User privilage:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD user priv 10 4 1
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD user list 1
	
	# 3.管理卡IP配置模式转换（DHCP/静态IP）
	echo -e "\n\n=======OOB IP Mode:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD lan set 1 ipsrc 
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD lan set 1 ipsrc static
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD lan print
	
	# 4.管理卡修改IP地址
	echo -e "\n\n=======Set IP:"
	read -p "modify oob ip, please use the current network : " oobip
	read -p "modify oob netmask : " netmask
	read -p "modify oob gateway : " oobgw
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD lan set 1 ipaddr $oobip
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD lan set 1 netmask $netmask
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD lan set 1 defgw ipaddr $oobgw
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD lan print
	
	# 5.管理卡配置模式转换（独立/共享） 仅dell
	echo -e "\n\n=======Lan Mode:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD delloem lan
	#ipmitool -I lan -H $HOST -U $USER -P $PASSWD delloem lan set dedicated
	
	# 6.设置SOL波特率
	echo -e "\n\n=======Sol volatile-bit-rate:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sol set non-volatile-bit-rate 115.2 1
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sol info 1
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sol set non-volatile-bit-rate 57.6 1
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sol info 1
	
	# 7.SOL模式开启、关闭
	echo -e "\n\n=======Sol enable and disable:"
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sol set enabled true 1
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sol info 1
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sol set enabled false 1
	ipmitool -I lan -H $HOST -U $USER -P $PASSWD sol info 1
}
echo >$HOST-report.txt
getinfo 2>&1 |tee -a $HOST-report.txt
operation 2>&1 |tee -a $HOST-report.txt

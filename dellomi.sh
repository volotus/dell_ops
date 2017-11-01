#!/bin/bash
#
# Dell OpenIPMI & OpenManage Installer
# Revision: July 22nd 2011
#
HOST=`hostname`
D=`date '+%d%m%y'`
echo "Dell OpenIPMI & OpenManage Automatic Installer"
echo "Revision: July 22nd 2011"
echo
echo "Installing Dell Yum Repository..."
echo
wget -q -O - http://linux.dell.com/repo/hardware/latest/bootstrap.cgi | bash
echo
echo "Dell Repository Install Complete!"
echo
echo "Installing Dell Server Administrator..."
echo
yum -y install srvadmin-all
echo
echo "Dell Server Administrator Install Complete!"
echo
echo "Starting Dell IPMI Services..."
echo
/opt/dell/srvadmin/sbin/srvadmin-services.sh start
echo
echo "Dell OpenIPMI & Dell OpenManage Install Complete!"
echo
echo "Please go to https://$HOST:1311 in order to access Dell OpenManage."
echo

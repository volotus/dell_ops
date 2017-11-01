#!/bin/bash
#for dell omsa install

wget -q -O - http://linux.dell.com/repo/hardware/latest/bootstrap.cgi | bash

sudo yum install srvadmin-all -y
sudo /etc/init.d/dataeng start
sudo /etc/init.d/dsm_om_connsvc start

#Go to https://<ip_address>:1311/ in your browser to access OMSA.

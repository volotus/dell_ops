#!/bin/bash

cd /opt

wget http://download.baidu.com/dell-dset-lx64-3.5.1.101.bin

chmod +x /opt/dell-dset-lx64-3.5.1.101.bin

yum install expect -y >/dev/null 2>&1


expect -c '
set timeout -1
spawn /opt/dell-dset-lx64-3.5.1.101.bin
expect {
      "*needed fo" { send "q"; exp_continue }
      "*for yes*" { send "y\r"; exp_continue }
      "*option (1-7):" { send "2\r"; exp_continue }
      "*hardware categories*" { send "y\r"; exp_continue }
      "*storage categories*" { send "y\r"; exp_continue }
      "*software categories*" { send "y\r"; exp_continue }
      "*linux log files*" { send "y\r"; exp_continue }
      "*advanced log files*" { send "y\r"; exp_continue }
      "*name and location*" { send "y\r"; exp_continue }
      "*see the User*" { send "n\r"; exp_continue }
      "*report is generated*" { send "n\r"; }
}
interact
'

/usr/bin/rsync -vzrtop --progress /root/DSET-*  8.8.8.8::dell


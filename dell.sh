#http://www.dell.com/support/my-support/cn/zh/cnbsd1/Products/ser_stor_net

#    查看厂商    # dmidecode| grep  "Manufacturer"
#    查看CPU个数    # dmidecode | grep  "Socket Designation: CPU" |wc –l
#    查看出厂日期    # dmidecode | grep "Date"
echo '机器型号'
sudo dmidecode | grep  "Product"
echo '序列号'
sudo dmidecode | grep  "Serial Number"

#===============================
echo '查看cpu型号'
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c

echo '查看物理cpu个数'
grep 'physical id' /proc/cpuinfo | sort -u | wc -l


echo '查看核心数量'
grep 'core id' /proc/cpuinfo | sort -u | wc -l

echo '线程数'
grep 'processor' /proc/cpuinfo | sort -u | wc -l


#===============================
echo 'memory'
free -m
#dmidecode | grep -A16 "Memory Device$"


#===============================
echo 'disk'
df -h
fdisk -l

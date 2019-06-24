#!/usr/sh

#install mysql

#mkdir
if [ ! -d "/data/sofe" ]; then
	mkdir -p "/data/sofe"
fi

#uninstall mariadb
mdb=`rpm -qa|grep mariadb|grep libs`
if [ -n "$mdb" ]
then
    mddArr=($mdb)
    for((i=0;i<${#mddArr[@]};i++))
        do
#        echo ${mddArr[$i]}
        eval `rpm -e --nodeps "${mddArr[$i]}"`
        done
fi

cd /data/sofe

if [ ! -f "/data/sofe/mysql-5.7.11-linux-glibc2.5-x86_64.tar.gz" ]; then
	wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.26-linux-glibc2.12-x86_64.tar.gz
	tar -zxvf mysql-5.7.26-linux-glibc2.12-x86_64.tar.gz -C /usr/local/
#	else
#	tar -zxvf /data/sofe/mysql-5.7.11-linux-glibc2.5-x86_64.tar.gz -C /usr/local/
fi

tar -zxvf /data/sofe/mysql-5.7.11-linux-glibc2.5-x86_64.tar.gz -C /usr/local/

cd /usr/local
mv mysql-5.7.11-linux-glibc2.5-x86_64 mysql

#创建mysql用户组，用户
groupadd mysql
useradd -g mysql mysql -d /home/mysql
#passwd mysql
chown -R mysql:mysql mysql/

cd /etc
# 下载配置文件
if [ -f "/etc/my.cnf" ]; then
	rm /etc/my.cnf
fi
wget https://raw.githubusercontent.com/ZyxZhou/conf/master/my.cnf

#根据配置文件创建目录
if [ ! -d "/var/lib/mysql" ]; then
	mkdir -p "/var/lib/mysql"
fi
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mkdir -p "/var/lib/mysql/mysql"
fi
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql/mysql

cd /usr/local/mysql
chown -R mysql:mysql ./

cd /usr/local/mysql/bin
#链接库文件
yum install  libaio-devel.x86_64

chown 777 /etc/my.cnf
./mysqld --initialize --user=mysql


# 复制启动脚本到资源目录
cp ../support-files/mysql.server /etc/rc.d/init.d/mysqld

# 增加mysqld服务控制脚本执行权限
chmod +x /etc/rc.d/init.d/mysqld

# 将mysqld服务加入到系统服务
chkconfig --add mysqld
# 检查mysqld服务是否已经生效
chkconfig --list mysqld

# 切换至mysql用户，启动mysql
service mysql start

echo PATH=$PATH:/usr/local/mysql/bin >> /etc/profile
source /etc/profile


#set password for root@localhost=password("123456");


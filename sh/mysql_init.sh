#!/usr/sh

#install mysql

#mkdir
if [ ! -d "/data/sofe" ]; then
	mkdir -p "/data/sofe"
fi

#uninstall mariadb
mdb=`rpm -qa|grep mariadb`
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
	wget http://nginx.org/download/nginx-1.12.2.tar.gz
fi
if [ ! -d "/data/sofe/mysql-5.7.11-linux-glibc2.5-x86_64.tar.gz" ]; then
	tar -zxvf /data/sofe/mysql-5.7.11-linux-glibc2.5-x86_64.tar.gz /usr/local
fi

cd /usr/local
mv mysql-5.7.11-linux-glibc2.5-x86_64 mysql
chown -R mysql:mysql mysql/

cd /etc
# 下载配置文件
wget https://raw.githubusercontent.com/ZyxZhou/conf/master/nginx.conf
./mysqld --initialize --user=mysql

# 复制启动脚本到资源目录
cp ./support-files/mysql.server /etc/rc.d/init.d/mysqld

# 增加mysqld服务控制脚本执行权限
chmod +x /etc/rc.d/init.d/mysqld

# 将mysqld服务加入到系统服务
chkconfig --add mysqld

# 切换至mysql用户，启动mysql
service root start

echo PATH=$PATH:/usr/local/mysql/bin >> /etc/profile
source /etc/profile


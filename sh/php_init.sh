#!/bin/sh

#install php

#mkdir
if [ ! -d "/data/sofe" ]; then
	mkdir -p "/data/sofe"
fi
if [ ! -d "/data/php" ]; then
	mkdir -p "/data/php"
fi
if [ ! -d "/data/www" ]; then
	mkdir -p "/data/www"
fi

#install lib
yum -y install wget gcc gcc-c autoconf automake libxml2-devel bzip2 bzip2-devel openssl-devel gnutls-devel libjpeg-devel libpng-devel libXpm-devel freetype-devel libmcrypt-devel mysql-devel libxslt-devel curl-devel
cd /data/sofe/php-7.2.19

#compile php
cd /data/sofe
if [ ! -f "/data/sofe/php-7.2.19.tar.gz" ]; then
	wget https://www.php.net/distributions/php-7.2.19.tar.gz
fi
if [ ! -d "/data/sofe/php-7.2.19" ]; then
	tar -zxvf php-7.2.19.tar.gz
fi

cd /data/sofe/php-7.2.19
./configure --prefix=/data/php --with-config-file-path=/data/php --enable-xml --enable-fpm --with-freetype-dir=/usr/include/freetype2/freetype/  --with-zlib --enable-mbstring --with-openssl --with-mysql --enable-posix --with-mysqli --with-mysql-sock --with-gd --with-jpeg-dir --enable-gd-native-ttf  --enable-pdo --with-pdo-mysql --enable-tokenizer --with-gettext --with-curl --enable-sockets --enable-bcmath --with-bz2 --enable-zip
make && make install

#download conf
cd /data/php
wget https://raw.githubusercontent.com/ZyxZhou/conf/master/php.ini

cd /data/php/etc
wget https://raw.githubusercontent.com/ZyxZhou/conf/master/php-fpm.conf

#add to environment
echo PATH=$PATH:/data/php/bin >> /etc/profile
source /etc/profile

#fpm auto-start
echo /data/php/sbin/php-fpm >> /etc/rc.d/rc.local
chmod 777 /etc/rc.d/rc.local

#start fpm
/data/php/sbin/php-fpm

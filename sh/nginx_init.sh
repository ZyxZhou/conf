#!/bin/sh

#install nginx

#mkdir
if [ ! -d "/data/sofe" ]; then
	mkdir -p "/data/sofe"
fi
if [ ! -d "/data/nginx" ]; then
	mkdir -p "/data/nginx"
fi
if [ ! -d "/data/www" ]; then
	mkdir -p "/data/www"
fi

#install lib
yum -y install wget gcc gcc-c autoconf automake pcre-devel openssl-devel zlib-devel

#compile nginx
cd /data/sofe
if [ ! -f "/data/sofe/nginx-1.12.2.tar.gz" ]; then
	wget http://nginx.org/download/nginx-1.12.2.tar.gz
fi
if [ ! -d "/data/sofe/nginx-1.12.2" ]; then
	tar -zxvf nginx-1.12.2.tar.gz
fi

groupadd nginx
useradd -g nginx nginx

cd /data/sofe/nginx-1.12.2
./configure --prefix=/data/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-threads --with-stream --with-stream_ssl_module --with-http_slice_module --with-mail --with-mail_ssl_module --with-file-aio --with-http_v2_module --with-ipv6
make && make install

#download conf(default port 1234)
cd /data/nginx/conf
rm -f nginx.conf
wget https://raw.githubusercontent.com/fadexiii/conf/master/nginx.conf

if [ ! -d "/data/nginx/conf/vhost" ]; then
	mkdir -p "/data/nginx/conf/vhost"
fi

cd /data/nginx/conf/vhost
wget https://raw.githubusercontent.com/fadexiii/conf/master/www.conf

#auto-start
echo /data/nginx/sbin/nginx >> /etc/rc.d/rc.local
chmod 777 /etc/rc.d/rc.local

#start nginx
/data/nginx/sbin/nginx

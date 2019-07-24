#!/bin/sh
ifconfig
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php7/php.ini 
sed -i 's/expose_php = On/expose_php = Off/g' /etc/php7/php.ini 
sed -i 's+;date.timezone =+date.timezone = Europe/Kiev+g' /etc/php7/php.ini 
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php7/php.ini 
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php7/php.ini 
sed -i 's/max_input_time = 60/max_input_time = 600/g' /etc/php7/php.ini 
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php7/php.ini 

rm /var/www/localhost/htdocs -R 
ln -s /usr/share/webapps/zabbix /var/www/localhost/htdocs

chown -R lighttpd /usr/share/webapps/zabbix/conf 

mkdir -p /var/run/lighttpd/
chown lighttpd /var/run/lighttpd 
/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
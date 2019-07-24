#!/bin/sh

mysql -h mysql -P 3306 -uroot -ppassword -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -h mysql -P 3306 -uroot -ppassword -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'password';"

cat /usr/share/zabbix/database/mysql/schema.sql | mysql -uzabbix -ppassword zabbix
cat /usr/share/zabbix/database/mysql/images.sql | mysql -uzabbix -ppassword zabbix
cat /usr/share/zabbix/database/mysql/data.sql | mysql -uzabbix -ppassword zabbix

#rm /var/www/localhost/htdocs -R 
#ln -s /usr/share/webapps/zabbix /var/www/localhost/htdocs 

sed -i 's/# DBPassword=/DBPassword=password/g' /etc/zabbix/zabbix_server.conf 
sed -i 's+# FpingLocation=/usr/sbin/fping+FpingLocation=/usr/sbin/fping+g' /etc/zabbix/zabbix_server.conf 
chown -R lighttpd /usr/share/webapps/zabbix/conf 

ifconfig

exec /usr/sbin/zabbix_server --foreground --config /etc/zabbix/zabbix_server.conf 

#wait
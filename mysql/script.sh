#!/bin/sh
#default parameters
MYSQL_ROOT_PWD=${MYSQL_ROOT_PWD:-"password"}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_USER_PWD=${MYSQL_USER_PWD:-""}
MYSQL_USER_DB=${MYSQL_USER_DB:-""}

if [[ ! -d "/run/mysqld" ]]; then
	echo "creating /run/mysqld"
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
else 
	echo "dir /run/mysqld already presented"
	chown -R mysql:mysql /run/mysqld
fi

if [[ ! -f "/run/mysqld/mysqld.sock" ]]; then
	echo "touch /run/mysqld/mysqld.sock"
	touch /run/mysqld/mysqld.sock
	chown -R mysql:mysql /run/mysqld/mysqld.sock
else 
	echo "file /run/mysqld/mysqld.sock"
	chown -R mysql:mysql /run/mysqld/mysqld.sock
fi

if [[ -d /var/lib/mysql/mysql ]]; then
	echo "dir /var/lib/mysql/mysql is already presented"
	chown -R mysql:mysql /var/lib/mysql/mysql
else
	echo "creating initial DB"
	mkdir -p /var/lib/mysql/mysql
	echo "/var/lib/mysql/mysq created"
	chown -R mysql:mysql /var/lib/mysql/mysql
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null
	echo "initialised"
	
	#creating temporary files
	tfile=`mktemp`
	if [[ ! -f $tfile ]]; then
		return 1
	fi
	
	#saving sql
	cat << EOF > $tfile

USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PWD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD' WITH GRANT OPTION ;
EOF

	#creating database

	if [[ "$MYSQL_USER_DB" != "" ]]; then
		echo "[i] Creating database: $MYSQL_USER_DB"
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_USER_DB\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

		if [[ "$MYSQL_USER" != "" ]]; then
			echo "Creating user $MYSQL_USER with password $MYSQL_USER_PWD"
			echo "GRANT ALL ON \`$MYSQL_USER_DB\`.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PWD';" >> $tfile
		fi
	fi

	echo 'FLUSH PRIVILEGES;' >> $tfile

	#running

	echo "run $tfile"
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile
	rm -f $tfile
fi

echo 'start running mysqld'

exec /usr/bin/mysqld --user=mysql --skip-name-resolve --skip-networking=0


#/bin/sh
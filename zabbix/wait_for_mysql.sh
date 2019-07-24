#!/bin/sh
set -e
set -x

host="$1"
shift
cmd="$@"

until mysql -h mysql -P 3306 -uroot -ppassword -e "select 1;"; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "Mysql is up - executing command"
exec /scripts/script.sh
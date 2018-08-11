#!/bin/bash

set -Eeo pipefail

echo "[$(date)] Preparing environment..."

until ( mysql -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD -e"select current_timestamp;" $MYSQL_DATABASE ) ; do 
	echo "[$(date)] Waiting for DB..."
	sleep 5
done

cd /opt/bookstack

cp .env.example .env
sed -e "s/DB_DATABASE=.*\$/DB_DATABASE=$MYSQL_DATABASE/" \
	-e "s/DB_USERNAME=.*\$/DB_USERNAME=$MYSQL_USER/" \
	-e "s/DB_PASSWORD=.*\$/DB_PASSWORD=$MYSQL_PASSWORD/" \
	-e "s/DB_HOST=.*\$/DB_HOST=$MYSQL_HOST/" \
	-i .env
#


php artisan key:generate --no-interaction --force
php artisan migrate --no-interaction --force

echo "[$(date)] Running process..."

/usr/sbin/apache2ctl -D FOREGROUND


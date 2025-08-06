#!/bin/bash

# for now only install.sh PHP 8.2

if [ -f /var/www/isdeployed ]; then
    tail -f /var/www/fado/log/access.log
    exit 0
fi

sh /var/www/fado/install.sh
touch /var/www/isdeployed
tail -f /var/www/fado/log/access.log
exit 0

echo "deploy container on first run"

cwd=$(dirname "$0")

rm /etc/apt/sources.list.d/php.list
apt update
apt install -y ca-certificates git gnupg gnupg1 gnupg2
touch /etc/apt/sources.list.d/php.list
sh -c 'echo "deb [trusted=yes] https://packages.sury.org/php/ bookworm main" > /etc/apt/sources.list.d/php.list'
apt-key adv --fetch-keys https://packages.sury.org/php/apt.gpg

apt update
apt upgrade -y
apt install -y apache2 php8.4-common php8.4-cli php8.4-intl php8.4-mysql php8.4-mbstring mariadb-client mariadb-common mariadb-server php8.4-memcache php-memcached memcached mycli php-mariadb-mysql-kbs htop nano libssl3 libc6 libsasl2-2 php8.4-opcache libffi8 libicu72 php8.4-readline

localedef -f UTF-8 -i tr_TR tr_TR.utf8
localedef -f UTF-8 -i de_DE de_DE.utf8
localedef -f UTF-8 -i en_GB en_GB.utf8
localedef -f UTF-8 -i es_ES es_ES.utf8

phppath=$(which php)
phpv=""
compile=true

sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/g' /usr/local/lib/php.ini
sed -i 's/;extension=pdo_ocdb/extension=pdo_ocbd/g' /usr/local/lib/php.ini
sed -i 's/;extension=mbstring/extension=mbstring/g' /usr/local/lib/php.ini
sed -i 's/;extension=intl/extension=intl/g' /usr/local/lib/php.ini
sed -i 's/#socket = \/run\/mysqld\/mysqld.sock/socket = \/var\/mysql\/mysql.sock/g' /etc/mysql/my.cnf
sed -i 's/listen = 127\.0\.0\.1:9000/listen = \/var\/run\/php\/php-fpm.sock/g' /usr/local/etc/php-fpm.d/www.conf

if [ "$phppath" != "" ]; then
   phpv=$(php -v | grep -e "HP.*(c" -o)
else
   compile=true
fi
if [ "$phpv" != "HP 8.4.10 (c" ]; then
   compile=true
fi
if [ $compile ]; then
    sh $cwd/compilephp.sh
fi

rm /etc/apache2/sites-available/000-default.conf
rm /etc/apache2/sites-available/default-ssl.conf

/usr/sbin/a2enmod rewrite
/usr/sbin/a2enmod headers
/usr/sbin/a2enmod ssl

php-fpm -D
service mariadb restart
service memcached restart
service apache2 restart

mariadb -u root -e "CREATE USER IF NOT EXISTS fado@localhost IDENTIFIED BY 'rood';"
mariadb -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'fado'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadb -u root -e "DROP DATABASE IF EXISTS fado; CREATE DATABASE fado DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
mariadb -u root -e "GRANT ALL PRIVILEGES ON fado.* TO 'fado'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadb -u fado -prood fado < /var/www/html/fado-DML.sql 2>&1

chgrp -R www-data /var/run/php/
chown -R www-data /var/www
chgrp -R www-data /var/www
chmod -R 771 /var/www

touch /var/www/isdeployed

echo "successfuly deployed LAMP"

tail -f /var/www/log/access.log
exit 0

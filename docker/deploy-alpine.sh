#!/bin/bash
#
# udocker run --entrypoint="/bin/busybox sh" --volume="/data/data/com.termux/files/home/git/fado/:/var/www/html" alpine:latest
# cd /var/www/html/docker
# busybox sh deploy-alpine.sh

export XDG_RUNTIME_DIR=/run/$(id -u)

cwd=$(dirname "$0")

if [ -f /var/www/isdeployed ]; then
    /etc/init.d/apache2 -U restart
    /etc/init.d/mariadb -U restart
    /etc/init.d/php-fpm84 -U restart
    /etc/init.d/memcached -U restart
    /etc/init.d/apache2 -U status
    /etc/init.d/mariadb -U status
    /etc/init.d/php-fpm84 -U status
    /etc/init.d/memcached -U status
    tail -f /var/log/apache2/other_vhosts_access.log
    exit 0
fi

echo "Download & install packages"

apk add openrc udev-init-scripts-openrc apache2 php php-fpm php-intl php-pdo_mysql php-mbstring php-cli mariadb php-memcache memcached htop nano musl-locales mariadb-common mariadb-openrc mariadb-connector-c apache2-ssl

adduser -D www-data
chown -R www-data $cwd/*
chmod -R 770 $cwd/*

echo "Start & prepare MariaDB"

adduser -D mariadb

/etc/init.d/mariadb -U setup
/etc/init.d/mariadb -U start

mariadbd -u root -e "CREATE USER IF NOT EXISTS fado@localhost IDENTIFIED BY 'rood';"
mariadbd -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'fado'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadbd -u root -e "DROP DATABASE IF EXISTS fado; CREATE DATABASE fado DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
mariadbd -u root -e "GRANT ALL PRIVILEGES ON fado.* TO 'fado'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadbd -u fado -prood fado < /var/www/html/fado-DML.sql

rm /var/www/html/database.csv

cat <<EOF >> /var/www/html/database.csv
user;fado
pwd;rood
db;fado
host;127.0.0.1
port;3306
charset;utf8
socket;/var/mysqld/mysqld.pid
EOF

echo "Configure and start Apache webserver and memcached RAM"

sed -i -e 's/#LoadModule http2_module/LoadModule http2_module/g' /etc/apchache2/conf.d/default.conf
sed -i -e 's/#LoadModule rewrite_module/LoadModule rewrite_module/g' /etc/apchache2/conf.d/default.conf

rm /etc/apache2/sites-available/*
rm /etc/apache2/sites-enabled/*

cat <<EOF >> /etc/apache2/sites-available/fado.conf
ServerName fado.org

<VirtualHost _default_:80>
        ServerAdmin admin@fado.org
        DocumentRoot /var/www/html/
        ServerName fado.org

        <IfModule mod_headers.c>
            Header set Access-Control-Allow-Origin "*"
            Header set Access-Control-Allow-Credentials "true"
            Header set Access-Control-Max-Age "3600"
        </IfModule>

        <FilesMatch \.(php|phtml)$>
            SetHandler "proxy:fcgi://127.0.0.1:9000"
        </FilesMatch>

        <IfModule mod_ssl.c>
            <IfModule mod_rewrite.c>
                RewriteEngine on
                RewriteCond "%{HTTPS}" on
                RewriteRule "^/?(.*)" "https://%{SERVER_NAME}/$1" [L,R=301]
            </IfModule>
        </IfModule>

        <IfModule mod_rewrite.c>
            RewriteEngine on
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule "/(.*)/$" "/index.php?page=$1" [L,QSA]
        </IfModule>

        <FilesMatch "\.(csv|md|sql|sh|log)$">
            Require all denied
        </FilesMatch>

        ErrorDocument 404 /index.php?page=404
        ErrorDocument 403 /index.php?page=403
</VirtualHost>
<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerAdmin admin@fado.org
        DocumentRoot /var/www/html/
        ServerName fado.org

        <IfModule mod_headers.c>
            Header set Access-Control-Allow-Origin "*"
            Header set Access-Control-Allow-Credentials "true"
        </IfModule>

        <FilesMatch \.(php|phtml)$>
            SetHandler "proxy:fcgi://127.0.0.1:9000"
        </FilesMatch>

        <IfModule mod_rewrite.c>
            RewriteEngine on
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule "/(.*)/$" "/index.php?page=$1" [L,QSA]
        </IfModule>

        SSLEngine on
        SSLCertificateFile /home/fado/Desktop/SSL/ca.pem
        SSLCertificateChainFile /home/fado/Desktop/SSL/ca.chain.pem
        SSLCertificateKeyFile /home/fado/Desktop/SSL/key.pem

        <FilesMatch "\.(csv|md|sql|sh|log)$">
            Require all denied
        </FilesMatch>

        ErrorDocument 404 /index.php?page=404
        ErrorDocument 403 /index.php?page=403
    </VirtualHost>
</IfModule>
EOF

rm /var/www/html/index.html
ln -s /etc/apache2/sites-available/fado.conf /etc/apache2/sites-enabled/fado.conf

mkdir -p /run/0/openrc
touch /run/0/openrc/softlevel

rm /etc/apchache2/conf.d/ssl.conf

adduser -D apache
adduser -D memcached

/etc/init.d/apache2 -U restart
/etc/init.d/mariadb -U restart
/etc/init.d/php-fpm84 -U restart
/etc/init.d/memcached -U restart

/etc/init.d/apache2 -U status
/etc/init.d/mariadb -U status
/etc/init.d/php-fpm84 -U status
/etc/init.d/memcached -U status

touch /var/www/isdeployed
echo "true" > /var/www/isdeployed
tail -f /var/log/apache2/access.log
exit 0

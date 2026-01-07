#!/bin/bash
#
# udocker run --entrypoint="/bin/busybox sh" --volume="/data/data/com.termux/files/home/git/fado/:/var/www/localhost/htdocs" alpine:latest
# cd /var/www/localhost/htdocs/
# busybox sh deploy-alpine.sh

export XDG_RUNTIME_DIR=/run/$(id -u)
mkdir -p /run/openrc/
touch /run/openrc/softlevel
mkdir -p /run/0/openrc
touch /run/0/openrc/softlevel
adduser -D apache
adduser -D memcached
adduser -D mariadb
adduser -D mysql

cwd=$(dirname "$0")

if [ -f /var/www/isdeployed ]; then
    chown -c -R mysql /var/lib/mysql
    chmod -R 777 /var/lib/mysql
    mv /var/lib/mysql/aria_log_control /var/lib/mysql/aria_log_control.orig
    apk fix mariadb
    /etc/init.d/apache2 -U restart
    /etc/init.d/mariadb -U restart
    /etc/init.d/php-fpm84 -U restart
    /etc/init.d/memcached -U restart
    /etc/init.d/apache2 -U status
    /etc/init.d/mariadb -U status
    /etc/init.d/php-fpm84 -U status
    /etc/init.d/memcached -U status
    rc-service -l -s -U
    rc-status -a -U
    tail -f /var/log/apache2/access.log
    exit 0
fi

echo "Download & install packages"

apk add openrc udev-init-scripts-openrc apache2 php php-fpm php-intl php-pdo_mysql php-mbstring php-cli mariadb php-memcache memcached htop nano musl-locales mariadb-common mariadb-openrc mariadb-connector-c apache2-http2 apache2-ssl apache2-proxy

chown -R apache $cwd/*
chmod -R 770 $cwd/*

echo "Start & prepare MariaDB"

apk fix mariadb
rm -rf /var/lib/mysql/
/etc/init.d/mariadb -U setup
chown -c -R mysql /var/lib/mysql
chmod -R 777 /var/lib/mysql
mv /var/lib/mysql/aria_log_control /var/lib/mysql/aria_log_control.orig
/etc/init.d/mariadb -U start

mariadbd -u root -e "CREATE USER IF NOT EXISTS fado@localhost IDENTIFIED BY 'rood';"
mariadbd -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'fado'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadbd -u root -e "DROP DATABASE IF EXISTS fado; CREATE DATABASE fado DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
mariadbd -u root -e "GRANT ALL PRIVILEGES ON fado.* TO 'fado'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadbd -u fado -prood fado < /var/www/localhost/htdocs/fado-DML.sql

rm /var/www/localhost/htdocs/database.csv

cat <<EOF >> /var/www/localhost/htdocs/database.csv
user;fado
pwd;rood
db;fado
host;127.0.0.1
port;3306
charset;utf8
socket;/var/mysqld/mysqld.pid
EOF

echo "Configure and start Apache webserver and memcached RAM"

sed -i -e 's/#LoadModule http2_module/LoadModule http2_module/g' /etc/apache2/httpd.conf
sed -i -e 's/#LoadModule rewrite_module/LoadModule rewrite_module/g' /etc/apache2/httpd.conf
sed -i -e 's/LoadModule mpm_worker_module/#LoadModule mpm_worker_module/g' /etc/apache2/httpd.conf
sed -i -e 's/#LoadModule mpm_event_module/LoadModule mpm_event_module/g' /etc/apache2/httpd.conf
sed -i -e 's/LoadModule mpm_prefork_module/#LoadModule mpm_prefork_module/g' /etc/apache2/httpd.conf

rm /etc/apache2/conf.d/default.conf

cat <<EOF >> /etc/apache2/conf.d/fado.conf
DirectoryIndex index.php index.html

ServerName fado.org

<VirtualHost _default_:80>
        ServerAdmin admin@fado.org
        DocumentRoot /var/www/localhost/htdocs
        ServerName fado.org

        <IfModule mod_headers.c>
            Header set Access-Control-Allow-Origin "*"
            Header set Access-Control-Allow-Credentials "true"
            Header set Access-Control-Max-Age "3600"
        </IfModule>

        <FilesMatch "\.(php|phtml)$">
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
        DocumentRoot /var/www/localhost/htdocs
        ServerName fado.org

        <IfModule mod_headers.c>
            Header set Access-Control-Allow-Origin "*"
            Header set Access-Control-Allow-Credentials "true"
        </IfModule>

        <FilesMatch "\.(php|phtml)$">
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

rm /var/www/localhost/htdocs/index.html
rm /etc/apache2/conf.d/ssl.conf

/etc/init.d/apache2 -U restart
/etc/init.d/php-fpm84 -U restart
/etc/init.d/memcached -U restart

/etc/init.d/apache2 -U status
/etc/init.d/mariadb -U status
/etc/init.d/php-fpm84 -U status
/etc/init.d/memcached -U status

rc-service -l -s -U
rc-status -a -U

touch /var/www/isdeployed
echo "true" > /var/www/isdeployed
tail -f /var/log/apache2/access.log
exit 0

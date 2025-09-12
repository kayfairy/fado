#!/bin/bash

cwd=$(dirname "$0")

echo "Download & install packages"

apt update
apt upgrade -y
apt install -y apache2 php8.2 php8.2-fpm php8.2-intl php8.2-mysql php8.2-mbstring php8.2-cli mariadb-client mariadb-common mariadb-server php-mariadb-mysql-kbs php-memcache php-memcached memcached htop nano locales curl

echo "Compile locales"

localedef -f UTF-8 -i tr_TR tr_TR.utf8
localedef -f UTF-8 -i de_DE de_DE.utf8
localedef -f UTF-8 -i en_GB en_GB.utf8
localedef -f UTF-8 -i es_ES es_ES.utf8
localedef -f UTF-8 -i nl_NL nl_NL.utf8

chown -R www-data $cwd/*
chmod -R 770 $cwd/*
chgrp -R www-data $cwd/*

echo "Start & prepare MariaDB"

systemctl restart mariadb

mariadb -u root -e "CREATE USER IF NOT EXISTS fado@localhost IDENTIFIED BY 'rood';"
mariadb -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'fado'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadb -u root -e "DROP DATABASE IF EXISTS fado; CREATE DATABASE fado DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
mariadb -u root -e "GRANT ALL PRIVILEGES ON fado.* TO 'fado'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadb -u fado -prood fado < /var/www/html/fado-DML.sql

rm $cwd/database.csv

cat <<EOF >> $cwd/database.csv
user;fado
pwd;rood
db;fado
host;127.0.0.1
port;3306
charset;utf8
socket;/var/mysqld/mysqld.pid
EOF

echo "Configure and start Apache webserver and memcached RAM"

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
        </IfModule>

        # map and route delivered by
        # https://switch2osm.org/
        #
        # OSM tile server: https://github.com/gravitystorm/openstreetmap-carto.git
        # OSRM path finder: https://github.com/Project-OSRM/osrm-backend
        # HTML frontend: https://github.com/Leaflet/Leaflet
        #
        # include /etc/apache2/sites-available/tile.conf
        <IfModule mod_ssl.c>
            <IfModule mod_rewrite.c>
                RewriteEngine on
                RewriteCond "%{HTTPS}" on
                RewriteCond "%{SSL_PROTOCOL}" "(SSLv3|TLSv1|TLSv1.1|TLSv1.2)"             
                RewriteRule ".?" "-" [S=2]
                    RewriteRule "^/?(.*)" "https://%{SERVER_NAME}/$1" [L,R=301]                 
                    RewriteRule ".?" "-" [S=3]
                    RewriteCond %{REQUEST_FILENAME} !-d
                    RewriteCond %{REQUEST_FILENAME} !-f
                    RewriteRule "/(.*)/$" "/index.php?page=$1" [L,QSA]
            </IfModule>
        </IfModule>
        <IfModule mod_rewrite.c>
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

/usr/sbin/a2enmod rewrite
/usr/sbin/a2enmod headers
#/usr/sbin/a2enmod ssl
/usr/sbin/a2enmod proxy_fcgi setenvif
/usr/sbin/a2enconf php8.2-fpm
/usr/sbin/php-fpm8.2 -D

systemctl restart apache2
systemctl restart memcached

exit 0

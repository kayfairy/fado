#!/bin/bash

cwd=$(dirname "$0")

apt install apache2 php php7.2 php7.2-mysql php7.2-mbstring mysql-common mysql-server php-memcache php-memcached memcached

locale-gen de_DE de_DE.utf8 en_GB en_GB.utf8 tr_TR tr_TR.utf8

chown -R www-data $cwd/*
chmod -R a+rx $cwd/*

mysql -u root mysql -e "CREATE USER fado@localhost IDENTIFIED BY \"rood\";";
mysql -u root mysql -e "DROP DATABASE fado;";
mysql -u root mysql -e "CREATE DATABASE fado DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;";
mysql -u root mysql -e "GRANT ALL ON fado.* TO fado@localhost;";

mysql -u fado -prood fado < $cwd/database.sql

#rm $cwd/database.csv

#cat <<EOF >> $cwd/db_config.ini
#user;fado
#pwd;rood
#db;fado
#host;127.0.0.1
#port;3306
#charset;utf8
#EOF

cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.old
rm /etc/apache2/sites-available/000-default.conf

cat <<EOF >> /etc/apache2/sites-available/000-default.conf
ServerName fado.org

<VirtualHost _default_:80>
        ServerAdmin admin@fado.org
        DocumentRoot /var/www/fado
        ServerName fado.org

        #Include /etc/apache2/sites-available/tile.conf

        <IfModule mod_rewrite.c>
            RewriteEngine on
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule /(.*)/$ /index.php?page=\$1 [L,QSA]
        </IfModule>

        <FilesMatch "\.(csv|md|sql|sh)$">
            Require all denied
        </FilesMatch>

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        ErrorDocument 404 /index.php?page=404
        ErrorDocument 403 /index.php?page=403
</VirtualHost>
<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerAdmin admin@fado.org
        DocumentRoot /var/www/fado
        ServerName fado.org

        SSLEngine on
        SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
        SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

        <IfModule mod_rewrite.c>
            RewriteEngine on
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule /(.*)/$ /index.php?page=\$1 [L,QSA]
        </IfModule>

        <FilesMatch "\.(csv|md|sql|sh)$">
            Require all denied
        </FilesMatch>

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        ErrorDocument 404 /index.php?page=404
        ErrorDocument 403 /index.php?page=403
    </VirtualHost>
</IfModule>
EOF

a2enmod rewrite
a2enmod ssl
service apache2 restart

service memcached restart

exit 0

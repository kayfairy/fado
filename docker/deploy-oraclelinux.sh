#!/bin/bash
#  rockylinux:9.3

cwd=$(dirname "$0")

if [ -f /var/www/isdeployed ]; then
    service httpd restart
    service mariadb restart
    service php-fpm restart
    service memcached restart
    service --status-all
    tail -f /var/log/apache2/access.log
    exit 0
fi

echo "Download & install packages"

yum update && yum upgrade -y
yum install -y httpd mariadb-client mariadb-server php php-pdo php-mbstring php-fpm php-intl memcached nano git glibc-locale-source initscripts-service ntsysv

echo "Compile locales"

localedef -f UTF-8 -i tr_TR tr_TR.utf8
localedef -f UTF-8 -i de_DE de_DE.utf8
localedef -f UTF-8 -i en_GB en_GB.utf8
localedef -f UTF-8 -i es_ES es_ES.utf8
localedef -f UTF-8 -i nl_NL nl_NL.utf8
localedef -f UTF-8 -i tr_TR tr_TR.utf8
localedef -f UTF-8 -i de_DE de_DE.utf8
localedef -f UTF-8 -i en_GB en_GB.utf8
localedef -f UTF-8 -i es_ES es_ES.utf8
localedef -f UTF-8 -i fr_FR fr_FR.utf8
localedef -f UTF-8 -i fa_IR fa_IR.utf8
localedef -f UTF-8 -i iw_IL iw_IL.utf8
localedef -f UTF-8 -i ar_AR ar_AR.utf8
localedef -f UTF-8 -i ru_RU ru_RU.utf8

chown -R www-data $cwd/*
chmod -R 770 $cwd/*
chgrp -R www-data $cwd/*

echo "Start & prepare MariaDB"

service mariadb restart

mariadb -u root -e "CREATE USER IF NOT EXISTS fado@localhost IDENTIFIED BY 'rood';"
mariadb -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'fado'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadb -u root -e "DROP DATABASE IF EXISTS fado; CREATE DATABASE fado DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
mariadb -u root -e "GRANT ALL PRIVILEGES ON fado.* TO 'fado'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadb -u fado -prood fado < /var/www/html/fado-DML.sql

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

rm /etc/httpd/sites-available/*
rm /etc/httpd/sites-enabled/*

cat <<EOF >> /etc/httpd/sites-available/fado.conf
ServerName fado.org

<VirtualHost _default_:80>
        ServerAdmin admin@fado.org
        DocumentRoot /var/www/html/
        ServerName fado.org

        <IfModule mod_headers.c>
            Header set Access-Control-Allow-Origin "*"
            Header set Access-Control-Allow-Credentials "true"
        </IfModule>

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
ln -s /etc/httpd/sites-available/fado.conf /etc/httpd/sites-enabled/fado.conf

/usr/sbin/a2enmod rewrite
/usr/sbin/a2enmod headers
#/usr/sbin/a2enmod ssl
/usr/sbin/a2enmod proxy_fcgi setenvif
/usr/sbin/a2enconf php-fpm

service httpd restart
service mariadb restart
service php-fpm restart
service memcached restart
service --status-all

touch /var/www/isdeployed
echo "true" > /var/www/isdeployed
tail -f /var/log/apache2/access.log

exit 0

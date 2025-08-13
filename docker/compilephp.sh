#!/bin/bash

cwd=$(dirname "$0")
down=true
extract=true
libsdir=$cwd/libs

mkdir $libsdir
cd $libsdir

apt install -y build-essential autoconf libtool bison re2c libxml2 libxml2-dev libssl3 libssl-dev apache2-ssl-dev libsqlite3-dev zlib1g-dev git libonig5 libonig-dev wget unzip tar patch

if [ $down ]; then
   wget -O zlib.tar.gz https://www.zlib.net/zlib-1.3.1.tar.gz
   wget -O oniguruma.zip https://github.com/kkos/oniguruma/archive/refs/tags/v6.9.10.zip
   wget -O icu.zip https://github.com/unicode-org/icu/releases/download/release-72-1/icu4c-72_1-src.zip
   wget -O libxml.zip https://gitlab.gnome.org/GNOME/libxml2/-/archive/v2.14.5/libxml2-v2.14.5.zip 
   wget -O sqlite.zip https://sqlite.org/2025/sqlite-src-3500200.zip
   wget -O openssl.tar.gz https://github.com/openssl/openssl/releases/download/openssl-3.5.1/openssl-3.5.1.tar.gz
   wget -O php.tar.gz https://www.php.net/distributions/php-8.4.10.tar.gz
fi

if [ $extract ]; then
   mkdir zlib
   cp zlib.tar.gz zlib/
   cd zlib/
   tar xzvf zlib.tar.gz
   cd ..
   mkdir oniguruma
   cp oniguruma.zip oniguruma/
   cd oniguruma/
   unzip oniguruma.zip
   cd ..
   mkdir icu
   cp icu.zip uci/
   cd icu
   unzip icu.zip
   cd ..
   mkdir libxml
   cp libxml.zip libxml/
   cd libxml/
   unzip libxml.zip
   cd ..
   mkdir sqlite
   cp sqlite.zip sqlite/
   cd sqlite/
   unzip sqlite.zip
   cd ..
   mkdir openssl
   cp openssl.tar.gz openssl/
   cd openssl/
   tar xzvf openssl.tar.gz
   cd ..
   rm -f php/
   mkdir php
   cp php.tar.gz php/
   cd php/
   tar xzvf php.tar.gz
   cd php-8.4.10/
fi

export LIBXML_CFLAGS=-I$libsdir/libxml/libxml2-v2.14.5/include
export LIBXML_LIBS=-L$libsdir/libxml/libxml2-v2.14.5/lib
export OPENSSL_CFLAGS=-I$libsdir/openssl/openssl-3.5.1/include
export OPENSSL_LIBS=-L$libsdir/openssl/openssl-3.5.1/lib
export SQLITE_CFLAGS=-I$libsdir/sqlite/sqlite-src-3500200/include
export SQLITE_LIBS=-L$libsdir/sqlite/sqlite-src-3500200/lib
export ICU_CFLAGS=-I$libsdir/icu/icu/src/include
export ICU_LIBS=-L$libsdir/icu/icu/src/lib
export ONIG_CFLAGS=-I$libsdir/oniguruma/oniguruma-6.9.10/src/include
export ONIG_LIBS=-L$libsdir/oniguruma/oniguruma-6.9.10/src/lib
export ZLIB_CFLAGS=-I$libsdir/zlib/zlib-1.3.1/include
export ZLIB_LIBS=-L$libsdir/zlib/zlib-1.3.1/lib

cp $cwd/php_libxml.patch $libsdir/php/php-8.4.10/
cd $libsdir/php/php-8.4.10/
patch < ./php_libxml.patch

./buildconf

./configure --enable-ftp \
            --with-gettext \
            --enable-fpm \
            --with-fpm-user=www-data \
            --with-fpm-group=www-data \
            --enable-mbstring=shared \
            --with-openssl \
            --with-pdo-mysql=shared \
            --with-mysql-sock=/var/mysql/mysql.sock \
            --enable-calendar \
            --with-gnu-ld \
            --enable-soap \
            --enable-sockets \
            --enable-intl=shared \
	    --disable-phpdbg \
            --disable-phpdbg-webhelper \
            --disable-cgi

make -j $(nproc)

make install

php -v

php-fpm -v

exit 0

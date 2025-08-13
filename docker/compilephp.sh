#!/bin/bash

cwd=$(dirname "$0")
down=$1
extract=$2
libsdir=$cwd/libs

mkdir $libsdir
cd $libsdir

apt update && apt upgrade -y
apt install -y build-essential autoconf libtool bison re2c git wget unzip tar patch

if [ "$down" = true ]; then
   wget -O zlib.tar.gz https://www.zlib.net/zlib-1.3.1.tar.gz
   wget -O oniguruma.zip https://github.com/kkos/oniguruma/archive/refs/tags/v6.9.10.zip
   wget -O icu.zip https://github.com/unicode-org/icu/releases/download/release-72-1/icu4c-72_1-src.zip
   wget -O libxml.tar.xz https://download.gnome.org/sources/libxml2/2.14/libxml2-2.14.0.tar.xz
   wget -O sqlite.zip https://sqlite.org/2025/sqlite-src-3500200.zip
   wget -O openssl.tar.gz https://github.com/openssl/openssl/releases/download/openssl-3.5.1/openssl-3.5.1.tar.gz
   wget -O php.tar.gz https://www.php.net/distributions/php-8.4.11.tar.gz
   wget -O gettext.tar.gz https://ftp.gnu.org/pub/gnu/gettext/gettext-0.26.tar.gz
fi

if [ "$extract" = true ]; then
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
   cp libxml.tar.xz libxml/
   cd libxml/
   tar xvf libxml.tar.xz
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
   mkdir gettext
   cp gettext.tar.gz gettext/
   cd gettext
   tar xzvf gettext.tar.gz
   cd ..
   rm -f php/
   mkdir php
   cp php.tar.gz php/
   cd php/
   tar xzvf php.tar.gz
   cd php-8.4.11/
elif [ true ]; then
   cd php/php-8.4.11/ 
fi

export LIBXML_CFLAGS=-I$libsdir/libxml/libxml2-2.14.0/include
export LIBXML_LIBS=-L$libsdir/libxml/libxml2-2.14.0/lib
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
export INTL_CFLAGS=-I$libsdir/gettext/gettext-0.26/include
export INTL_LIBS=-L$libsdir/gettext/gettext-0.26/lib

./buildconf

./configure --enable-ftp \
            --with-gettext \
            --enable-fpm \
            --with-fpm-user=www-data \
            --with-fpm-group=www-data \
            --enable-mbstring \
            --with-openssl \
            --with-pdo-mysql=shared \
            --with-mysql-sock=/var/mysql/mysql.sock \
            --enable-calendar \
            --with-gnu-ld \
            --enable-libgcc \
            --with-curl \
            --with-zlib \
            --with-bz2 \
            --enable-bcmath \
            --enable-soap \
            --enable-sockets \
            --enable-intl \
	    --disable-phpdbg \
            --disable-phpdbg-webhelper \
            --disable-cgi

make -j $(nproc)

make install

php -v

php-fpm -v

exit 0

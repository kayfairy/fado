#!/bin/bash

down=$1
extract=$2
pak=$3
libsdir="$PWD/libs"

mkdir $libsdir
cd $libsdir

rm -r  extr/

if [ "$pak" = true ]; then
   dpkg-statoverride --remove "/etc/ssl/private"
   dpkg-statoverride --remove "/usr/lib/dbus-1.0/dbus-daemon-launch-helper"
   apt update && apt upgrade -y
   apt install -y build-essential autoconf libtool bison re2c git wget wget2 unzip tar patch libc6-dev
fi

if [ "$down" = true ]; then
   wget2 -O zlib.tar.gz https://www.zlib.net/zlib-1.3.1.tar.gz
   wget2 -O oniguruma.zip https://github.com/kkos/oniguruma/archive/refs/tags/v6.9.10.zip
   wget2 -O icu.zip https://github.com/unicode-org/icu/releases/download/release-77-1/icu4c-77_1-src.tgz
   wget2 -O libxml.tar.xz https://download.gnome.org/sources/libxml2/2.14/libxml2-2.14.0.tar.xz
   wget2 -O sqlite.zip https://sqlite.org/2025/sqlite-src-3500200.zip
   wget2 -O openssl.tar.gz https://github.com/openssl/openssl/releases/download/openssl-3.5.1/openssl-3.5.1.tar.gz
   wget2 -O php.tar.gz https://www.php.net/distributions/php-8.4.11.tar.gz
   wget2 -o gettext.zip https://github.com/autotools-mirror/gettext/archive/refs/tags/v0.26.tar.gz
   wget2 -O curl.tar.gz https://curl.se/download/curl-8.15.0.tar.gz
   wget2 -O sqlite.zip https://sqlite.org/2025/sqlite-src-3500400.zip
   wget2 -o ntp.tar.gz https://downloads.nwtime.org/ntp/ntp-4.2.8p18.tar.gz
fi

if [ "$extract" = true ]; then
   mkdir "$libsdir/extr"
   cd "$libsdir/extr"
   mkdir zlib
   cp "$libsdir/zlib.tar.gz" zlib/
   cd zlib/
   tar xzvf zlib.tar.gz
   cd ..
   mkdir oniguruma
   cp "$libsdir/oniguruma.zip" oniguruma/
   cd oniguruma/
   unzip -o oniguruma.zip
   cd ..
   mkdir icu
   cp "$libsdir/icu.zip" uci/
   cd icu
   unzip -o icu.zip
   cd ..
   mkdir libxml
   cp "$libsdir/libxml.tar.xz" libxml/
   cd libxml/
   tar xvf libxml.tar.xz
   cd ..
   mkdir ntp
   cp "$libsdir/ntp/ntp.tar.gz" ntp/
   cd ntp/
   tar xzvf ntp.tar.gz
   cd ..
   mkdir curl
   cp "$libsdir/curl.tar.bz2" curl/
   cd curl/
   tar xvf curl.tar.bz2
   cd ..
   mkdir sqlite
   cp "$libsdir/sqlite.zip" sqlite/
   cd sqlite/
   unzip -o sqlite.zip
   cd ..
   mkdir openssl
   cp "$libsdir/openssl.tar.gz" openssl/
   cd openssl/
   tar xzvf openssl.tar.gz
   cd ..
   mkdir gettext
   cp "$libsdir/gettext.zip" gettext/
   cd gettext
   unzip -o gettext.zip
   cd ..
   mkdir sqlite
   cp "$libsdir/sqlite.zip" sqlite/
   cd sqlite/
   unzip -o sqlite.zip
   cd ..
   rm -f php/
   mkdir php
   cp "$libsdir/php.tar.gz" php/
   cd php/
   tar xzvf php.tar.gz
   cd php-8.4.11/
elif [ true ]; then
   libsdir="$PWD/libs"
   cd "$PWD/libs/extr/php/php-8.4.11/"
fi

libsdir="$libsdir/extr"

export LIBXML_CFLAGS=-I$libsdir/libxml/libxml2-2.14.0/include
export LIBXML_LIBS=-L$libsdir/libxml/libxml2-2.14.0/lib
export OPENSSL_CFLAGS=-I$libsdir/openssl/openssl-3.5.1/include
export OPENSSL_LIBS=-L$libsdir/openssl/openssl-3.5.1/lib
export SQLITE_CFLAGS=-I$libsdir/sqlite/sqlite-src-3500200/include
export SQLITE_LIBS=-L$libsdir/sqlite/sqlite-src-3500200/lib
export ICU_CFLAGS=-I$libsdir/icu/icu/source/include
export ICU_LIBS=-L$libsdir/icu/icu/source/lib
export ONIG_CFLAGS=-I$libsdir/oniguruma/oniguruma-6.9.10/src/include
export ONIG_LIBS=-L$libsdir/oniguruma/oniguruma-6.9.10/src/lib
export ZLIB_CFLAGS=-I$libsdir/zlib/zlib-1.3.1/include
export ZLIB_LIBS=-L$libsdir/zlib/zlib-1.3.1/lib
export INTL_CFLAGS=-I$libsdir/gettext/gettext-master/include
export INTL_LIBS=-L$libsdir/gettext/gettext-master/lib
export CURL_CFLAGS=-I$libsdir/curl/curl-8.15.0/include
export CURL_LIBS=-L$libsdir/curl/curl-8.15.0/lib
export SQLITE_LIBS=-L$libsdir/sqlite/sqlite-src-3500400/lib
export SQLITE_CFLAGS=-I$libsdir/sqlite/sqlite-src-3500400/include
export NTP_LIBS=-L$libsdir/ntp/ntp-4.2.8p18/lib
export NTP_CFLAGS=-I$libsdir/ntp/ntp-4.2.8p18/include

cd "$libsdir/libxml/libxml2-2.14.0/"

./configure --without-python --without-debug --with-gnu-ld

make -j $(nproc)

cd "$libsdir/openssl/openssl-3.5.1/"

./Configure

make -j $(nproc)

cd "$libsdir/gettext/gettext-master"

./configure --with-gnu-ld

make -j $(nproc)

cd "$libsdir/icu/icu/source"

./configure

make -j $(nproc)

cd "$libsdir/curl/curl-8.15.0/"

./configure --without-python

make -j $(nproc)

cd "$libsdir/zlib/zlib-1.3.1/"

./configure

make -j $(nproc)

cd "$libsdir/oniguruma/oniguruma-6.9.10/"

./Configure

make -j $(nproc)

cd "$libsdir/sqlite/sqlite-src-3500400"

./configure --with-icu-ldflags=$ICU_LIBS --with-icu-cflags=$ICU_CFLAGS --icu-collations

make -j $(nproc)

cd "$libsdir/ntp/ntp-4.2.8p18"

./configure

cd "$libsdir/php/php-8.4.11/"

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
#            --with-curl \
            --with-sqlite3=$libsdir/sqlite/sqlite-src-3500400 \
            --with-zlib \

make -j $(nproc)

make install

php -v

php-fpm -v

exit 0

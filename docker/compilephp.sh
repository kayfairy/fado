#!/bin/bash
#
# sh docker/compilephp.sh true true true true
#
#
# ubuntu:25.04 debian:forky kalilinux/kali-last-release:latest
#

down=$1
extract=$2
pak=$3
op=$4

libsdir="$PWD/libs"

cd $libsdir

if [ "$pak" = "true" ]; then
   dpkg-statoverride --remove "/etc/ssl/private"
   dpkg-statoverride --remove "/usr/lib/dbus-1.0/dbus-daemon-launch-helper"
   apt update && apt upgrade -y
   apt install -y build-essential autoconf libtool bison re2c curl unzip tar patch libc6-dev pkgconf libsqlite3-dev libnpth0-dev libgnutls28-dev libsqlite3-dev libselinux-dev libsystemd-dev libxml2-dev
fi

if [ "$down" = "true" ]; then
   rm -r "$libsdir"
   mkdir "$libsdir"
   cd "$libsdir"
   curl --output zlib.tar.gz https://zlib.net/zlib-1.3.1.tar.xz
   curl --output oniguruma.zip https://github.com/kkos/oniguruma/archive/refs/tags/v6.9.10.zip
   curl --output icu.zip https://github.com/unicode-org/icu/releases/download/release-77-1/icu4c-77_1-src.tgz
   curl --output libxml.tar.xz https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz
   curl --output openssl.tar.gz https://github.com/openssl/openssl/releases/download/openssl-3.5.1/openssl-3.5.1.tar.gz
   curl --output php.tar.bz2 https://www.php.net/distributions/php-8.5.0.tar.bz2
   curl --output gettext.zip https://github.com/autotools-mirror/gettext/archive/refs/tags/v0.26.tar.gz
   curl --output curl.tar.gz https://curl.se/download/curl-8.15.0.tar.gz
   curl --output sqlite.zip https://sqlite.org/2025/sqlite-src-3500400.zip
   curl --output ntp.tar.gz https://downloads.nwtime.org/ntp/ntp-4.2.8p18.tar.gz
fi

if [ "$extract" = "true" ]; then
   rm -r "$libsdir/extr"
   mkdir "$libsdir/extr"
   cd "$libsdir/extr"
   mkdir zlib
   cp "$libsdir/zlib.tar.gz" zlib/
   cd zlib/
   tar xzvf zlib.tar.gz
   cd "$libsdir/extr"
   mkdir oniguruma
   cp "$libsdir/oniguruma.zip" oniguruma/
   cd oniguruma/
   unzip -u oniguruma.zip
   cd "$libsdir/extr"
   mkdir icu
   cp "$libsdir/icu.zip" icu/
   cd icu
   tar xvf icu.zip
   cd "$libsdir/extr"
   mkdir libxml
   cp "$libsdir/libxml.tar.xz" libxml/
   cd libxml/
   tar xvf libxml.tar.xz
   cd "$libsdir/extr"
   mkdir ntp
   cp "$libsdir/ntp/ntp.tar.gz" ntp/
   cd ntp/
   tar xzvf ntp.tar.gz
   cd "$libsdir/extr"
   mkdir curl
   cp "$libsdir/curl.tar.bz2" curl/
   cd curl/
   tar xvf curl.tar.bz2
   cd "$libsdir/extr"
   mkdir sqlite
   cp "$libsdir/sqlite.zip" sqlite/
   cd sqlite/
   unzip -u sqlite.zip
   cd  "$libsdir/extr"
   mkdir openssl
   cp "$libsdir/openssl.tar.gz" openssl/
   cd openssl/
   tar xzvf openssl.tar.gz
   cd "$libsdir/extr"
   mkdir gettext
   cp "$libsdir/gettext.tar.gz" gettext/
   cd gettext
   tar xvf gettext.tar.gz
   cd "$libsdir/extr"
   mkdir sqlite
   cp "$libsdir/sqlite.zip" sqlite/
   cd sqlite/
   unzip -u sqlite.zip
   cd "$libsdir/extr"
   mkdir curl/
   cp "$libsdir/curl.tar.gz" curl/
   cd curl/
   tar xvf curl.tar.gz
   cd "$libsdir/extr"
   rm -r php/
   mkdir php
   cp "$libsdir/php.tar.bz2" php/
   cd php/
   tar xvf php.tar.bz2
   cd php-8.5.0/
elif [ true ]; then
   cd "$libsdir/php/php-8.5.0/"
fi

libsdir="$libsdir/extr"

export LIBXML_CFLAGS=-I$libsdir/libxml/libxml2-2.15.1/include
export LIBXML_LIBS=-L$libsdir/libxml/libxml2-2.15.1/lib
export OPENSSL_CFLAGS=-I$libsdir/openssl/openssl-3.5.1/include
export OPENSSL_LIBS=-L$libsdir/openssl/openssl-3.5.1/lib
export PHP_SQLITE_CFLAGS=-I$libsdir/sqlite/sqlite-src-3500400/include
export PHP_SQLITE_LIBS=-L$libsdir/sqlite/sqlite-src-3500400/lib
export ICU_CFLAGS=-I$libsdir/icu/icu/source/include
export ICU_LIBS=-L$libsdir/icu/icu/source/lib
export ONIG_CFLAGS=-I$libsdir/oniguruma/oniguruma-6.9.10/src/include
export ONIG_LIBS=-L$libsdir/oniguruma/oniguruma-6.9.10/src/lib
export ZLIB_CFLAGS=-I$libsdir/zlib/zlib-1.3.1/include
export ZLIB_LIBS=-L$libsdir/zlib/zlib-1.3.1/lib
export INTL_CFLAGS=-I$libsdir/gettext/gettext-0.26/include
export INTL_LIBS=-L$libsdir/gettext/gettext-0.26/lib
export CURL_CFLAGS=-I$libsdir/curl/curl-8.15.0/include
export CURL_LIBS=-L$libsdir/curl/curl-8.15.0/lib
export SQLITE_LIBS=-L$libsdir/sqlite/sqlite-src-3500400/lib
export SQLITE_CFLAGS=-I$libsdir/sqlite/sqlite-src-3500400/include
export NTP_LIBS=-L$libsdir/ntp/ntp-4.2.8p18/lib
export NTP_CFLAGS=-I$libsdir/ntp/ntp-4.2.8p18/include
export LD_LIBRARY_PATH=/usr/lib

if [ "$op" = "true" ]; then

    cd "$libsdir/libxml/libxml2-2.15.1/"

    ./configure --without-python --without-debug --with-gnu-ld

    make -j $(nproc)

    cd "$libsdir/openssl/openssl-3.5.1/"

    ./Configure

    make -j $(nproc)

    cd "$libsdir/zlib/zlib-1.3.1/"

    ./configure

    make -j $(nproc)

    cd "$libsdir/ntp/ntp-4.2.8p18"

    ./configure --with-gnu-ld --without-threads --with-openssl

    make -j $(nproc)

    cd "$libsdir/gettext/gettext-0.26"

    $./configure --with-gnu-ld

    make -j $(nproc)

    cd "$libsdir/icu/icu/source"

    ./configure

    make -j $(nproc)

    cd "$libsdir/curl/curl-8.15.0/"

    ./configure --with-gnutls --without-python

     make -j $(nproc)

    cd "$libsdir/oniguruma/oniguruma-6.9.10/"

    autoreconf -vfi

    ./configure --with-gnu-ld

    make -j $(nproc)

    cd "$libsdir/sqlite/sqlite-src-3500400"

    ./configure --with-icu-ldflags=$ICU_LIBS --with-icu-cflags=$ICU_CFLAGS --icu-collations --without-icu

    make -j $(nproc)

fi

if [ true ]; then

    cd "$libsdir/php/php-8.5.0/"

    sed -i 's/<libxml\/xmlversion.h>/"..\/..\/..\/..\/..\/libxml\/libxml2-2.15.1\/include\/libxml\/xmlversion.h"/g' /var/www/html/libs/extr/php/php-8.5.0/include/libxml/parser.h
    sed -i 's/<zlib.h>/"..\/..\/..\/..\/..\/zlib\/zlib-1.3.1\/zlib.h"/g' /var/www/html/libs/extr/php/php-8.5.0/ext/mysqlnd/mysqlnd_protocol_frame_codec.c
    sed -i 's/<oniguruma.h>/"..\/..\/..\/..\/..\/oniguruma\/oniguruma-6.9.10\/src\/oniguruma.h"/g' /var/www/html/libs/extr/php/php-8.5.0/ext/mbstring/php_mbregex.c

    ./buildconf

    ./configure --enable-fpm=shared \
            --with-fpm-user=www-data \
            --with-fpm-group=www-data \
            --with-fpm-systemd
            --enable-mbstring \
            --with-pdo-mysql=shared \
            --with-mysql-sock=/var/mysql/mysql.sock \
            --enable-calendar \
            --with-intl=shared \
            --with-gnu-ld \
            --enable-libgcc \
            --disable-xmlwriter \
            --disable-xmlreader \
            --disable-simplexml \
            --with-libxml=shared \
            --enable-soap \
            --disable-cgi \
            --with-libdir \
#            --enable-phpdbg-debug \ 
#            --enable-debug

     make -j $(nproc)

     make install
fi

php -v

php-fpm -v

exit 0

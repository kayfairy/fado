#!/bin/bash
#
# udocker run --entrypoint="/usr/bin/fish" --volume="/data/data/com.termux/files/home/git/fado/:/var/www/html" debian:sid
# cd /var/www/html/docker
# ./compilephp.sh true true true 1F
# ./compilephp.sh $down_libs $extract_libs $install_pkgs $pre_compile_libs
#
# (x) debian:forky
#

down=$1
extract=$2
pak=$3
op=$4

libsdir="/var/www/html/libs"

cd $libsdir

if [ "$pak" = "true" ]; then
   dpkg-statoverride --remove "/etc/ssl/private"
   dpkg-statoverride --remove "/usr/lib/dbus-1.0/dbus-daemon-launch-helper"
   dpkg-statoverride --remove "/usr/bin/crontab"
   apt update && apt upgrade -y
   apt install -y make build-essential autoconf libtool binutils bison re2c wget tar gnulib gcc glibc-source lld llvm-dev libstdc++-15-dev libgcc-15-dev libstdc++6 libc6-dev clang pkgconf python3-icu libgnutls28-dev libpsl-dev libtestsweeper-dev libselinux-dev libapparmor-dev libsystemd-dev libacl1-dev python3-pylibacl libpthreadpool-dev libevent-dev libgclib-dev libnpth0-dev libglib2.0-dev python3-libxml2 libstdc++6-arm64-cross libgcc-15-dev-arm64-cross libc6-dev-arm64-cross libapr1-dev
fi

if [ "$down" = "true" ]; then
   rm -r "$libsdir"
   mkdir "$libsdir"
   cd "$libsdir"
   wget -O zlib.tar.gz  https://zlib.net/zlib-1.3.1.tar.gz
   wget -O oniguruma.tar.gz  https://github.com/kkos/oniguruma/releases/download/v6.9.10/onig-6.9.10.tar.gz
   wget -O icu.tgz https://github.com/unicode-org/icu/releases/download/release-78.2/icu4c-78.2-sources.tgz
   wget -O libxml.tar.xz  https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz
   wget -O openssl.tar.gz  https://github.com/openssl/openssl/releases/download/openssl-3.5.1/openssl-3.5.1.tar.gz
   wget -O php.tar.bz2  https://www.php.net/distributions/php-8.5.2.tar.bz2
   wget -O gettext.tar.gz  https://ftp.gnu.org/pub/gnu/gettext/gettext-0.26.tar.gz
   wget -O curl.tar.gz  https://curl.se/download/curl-8.17.0.tar.gz
   wget -O sqlite.tar.gz  https://sqlite.org/2025/sqlite-autoconf-3510100.tar.gz
   wget -O ntp.tar.gz  https://downloads.nwtime.org/ntp/ntp-4.2.8p18.tar.gz
   wget -O httpd.tar.bz2  https://dlcdn.apache.org/httpd/httpd-2.4.66.tar.bz2
   wget -O httpdfcgi.tar.bz2  https://dlcdn.apache.org/httpd/mod_fcgid/mod_fcgid-2.3.9.tar.bz2
   wget -O gnupth.tar.gz  ftp://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz
   wget -O memc.tar.gz  https://memcached.org/files/memcached-1.6.40.tar.gz
   wget -O maria.tar.gz https://github.com/MariaDB/server/archive/refs/tags/mariadb-12.3.1.tar.gz
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
   cp "$libsdir/oniguruma.tar.gz" oniguruma/
   cd oniguruma/
   tar xvfz oniguruma.tar.gz
   cd "$libsdir/extr"
   mkdir icu
   cp "$libsdir/icu.tgz" icu/
   cd icu
   tar xvf icu.tgz
   cd "$libsdir/extr"
   mkdir libxml
   cp "$libsdir/libxml.tar.xz" libxml/
   cd libxml/
   tar xvf libxml.tar.xz
   cd "$libsdir/extr"
   mkdir ntp
   cp "$libsdir/ntp.tar.gz" ntp/
   cd ntp/
   tar xzvf ntp.tar.gz
   cd "$libsdir/extr"
   mkdir gnupth
   cp "$libsdir/gnupth.tar.gz" gnupth/
   cd gnupth/
   tar xvfz gnupth.tar.gz
   cd "$libsdir/extr"
   mkdir curl
   cp "$libsdir/curl.tar.bz2" curl/
   cd curl/
   tar xvf curl.tar.bz2
   cd "$libsdir/extr"
   mkdir sqlite
   cp "$libsdir/sqlite.tar.gz" sqlite/
   cd sqlite/
   tar xzvf sqlite.tar.gz
   cd  "$libsdir/extr"
   mkdir maria
   cd maria
   cp "$libsdir/maria.tar.gz" maria/
   cd maria/
   tar xvfz maria.tar.gz
   cd  "$libsdir/extr"
   mkdir openssl
   cp "$libsdir/openssl.tar.gz" openssl/
   cd openssl/
   tar xzvf openssl.tar.gz
   cd "$libsdir/extr"
   mkdir gettext
   cp "$libsdir/gettext.tar.gz" gettext/
   cd gettext
   tar xzvf gettext.tar.gz
   cd "$libsdir/extr"
   mkdir httpd
   cp "$libsdir/httpd.tar.bz2" httpd/
   cd httpd/
   tar xvf httpd.tar.bz2
   mkdir httpdfcgi
   cd "$libsdir/extr"
   cp "$libsdir/httpdfcgi.tar.bz2" httpdfcgi/
   cd httpdfcgi/
   tar xvf httpdfcgi.tar.bz2
   cd "$libsdir/extr"
   mkdir memc
   cp "$libsdir/memc.tar.gz" memc/
   cd memc/
   tar xf memc.tar.gz
   cd "$libsdir/extr"
   rm -r php/
   mkdir php
   cp "$libsdir/php.tar.bz2" php/
   cd php/
   tar xvf php.tar.bz2
   cd php-8.5.2/
elif [ true ]; then
   cd "$libsdir/extr/php/php-8.5.2/"
fi

libsdir="$libsdir/extr"

export SYSTEMD_LIBS=/usr/lib/systemd
export PKG_CONFIG_PATH=/usr/lib/pkgconfig
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/openssl/openssl-3.5.1/libcrypto.pc
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/libxml/libxml2-2.15.1
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/sqlite/sqlite-autoconf-3510100
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/zlib/zlib-1.3.1/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/oniguruma/onig-6.9.10/src
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/icu/icu/source/i18n
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/icu/icu/source/common
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/icu/icu/source/io
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$(find /usr/include -name time.h | grep -v -E ".+?(sys|linux).+" -m  1)
export LIBXML_CFLAGS=-I$libsdir/libxml/libxml2-2.15.1/include
export LIBXML_LIBS=-L$libsdir/libxml/libxml2-2.15.1
export OPENSSL_CFLAGS=-I$libsdir/openssl/openssl-3.5.1/include
export OPENSSL_LIBS=-L$libsdir/openssl/openssl-3.5.1/lib
export PHP_SQLITE_CFLAGS=-I$libsdir/sqlite/sqlite-autoconf-3510100
export PHP_SQLITE_LIBS=-L$libsdir/sqlite/sqlite-autoconf-3510100
export ICU_CFLAGS="-I$libsdir/icu/icu/source/i18n -I$libsdir/icu/icu/source/common -I$libsdir/icu/icu/source/io"
export ICU_LIBS=-L$libsdir/icu/icu/source
export ONIG_CFLAGS=-I$libsdir/oniguruma/onig-6.9.10/src
export ONIG_LIBS=-L$libsdir/oniguruma/onig-6.9.10/src
export ZLIB_CFLAGS=-I$libsdir/zlib/zlib-1.3.1/include
export ZLIB_LIBS=-L$libsdir/zlib/zlib-1.3.1/lib
export INTL_CFLAGS=-I$libsdir/gettext/gettext-0.26/include
export INTL_LIBS=-L$libsdir/gettext/gettext-0.26/lib
export CURL_CFLAGS=-I$libsdir/curl/curl-8.17.0/include
export CURL_LIBS=-L$libsdir/curl/curl-8.17.0/lib
export SQLITE_LIBS=-L$libsdir/sqlite/sqlite-autoconf-3510100
export SQLITE_CFLAGS=-I$libsdir/sqlite/sqlite-autoconf-3510100
export NTP_LIBS=-L$libsdir/ntp/ntp-4.2.8p18/lib
export NTP_CFLAGS=-I$libsdir/ntp/ntp-4.2.8p18/include
export GNU_PTH=-L$libsdir/gnupth/pth-2.0.7
export LIBS="-L/lib -L/usr/lib -L/usr/local/include -L/usr/include $GNU_PTH $LIBXML_LIBS $OPENSSL_LIBS $ICU_LIBS $ONIG_LIBS $ZLIB_LIBS $INTL_LIBS $CURL_LIBS $SQLITE_LIBS $NTP_LIBS"
export LDFLAGS="-rdynamic -pthread $LIBS"
export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/include:/usr/local/include:$PKG_CONFIG_PATH"
export PATH="$PATH:$LD_LIBRARY_PATH"
export CXXFLAGS="-O $CXXFLAGS -std=c++17"
export CFLAGS="-O $CFLAGS -std=c11"
export CC=$(which gcc)
export LD=$(which ld)
export DEB_BUILD_OPTIONS="parallel=$(nproc) nocheck"

if [ "$op" = "true" ]; then

    cd "$libsdir/openssl/openssl-3.5.1/"

    ./Configure

#    make -j $(nproc)

    cd "$libsdir/gnupth/pth-2.0.7"

    ./configure --host=x86_64 --enable-pthread --build=arm

    cd "$libsdir/zlib/zlib-1.3.1/"

    ./configure

    make -j $(nproc)

    cd "$libsdir/libxml/libxml2-2.15.1/"

    ./configure --without-debug --with-zlib

    make -j $(nproc)

    cd "$libsdir/ntp/ntp-4.2.8p18"

    ./configure --with-crypto=openssl --with-openssl-libdir=$libsdir/openssl/openssl-3.5.1 --with-openssl-incdir=$libsdir/openssl/openssl-3.5.1/include

    make -j $(nproc)

    cd "$libsdir/icu/icu/source/"

    ./configure

    make -j $(nproc)

    cd "$libsdir/gettext/gettext-0.26"

    ./configure

    make -j $(nproc)

    cd "$libsdir/curl/curl-8.17.0/"

    ./configure --with-gnutls

    make -j $(nproc)

    cd "$libsdir/oniguruma/onig-6.9.10/"

    autoreconf -vfi

    ./configure

    make -j $(nproc)

    cd "$libsdir/sqlite/sqlite-autoconf-3510100"

    ./configure --with-icu-ldflags=$ICU_LIBS --with-icu-cflags=-I$libsdir/icu/icu/source/common --with-icu-cflags=-I$libsdir/icu/icu/source/i18n --with-icu-cflags=-I$libsdir/icu/icu/source/io --icu-collations

    make -j $(nproc)

fi

if [ true ]; then

    cd "$libsdir/php/php-8.5.2/"

    make clean

    ./buildconf -f

    ./configure --enable-fpm=shared \
            --with-fpm-user=www-data \
            --with-fpm-group=www-data \
            --with-fpm-systemd \
            --with-fpm-acl \
            --with-fpm-selinux \
            --with-fpm-apparmor \
            --with-pdo-mysql=shared \
            --with-mysql-sock="/var/mysqld/mysqld.pid" \
            --with-libxml=shared \
            --with-zlib \
            --enable-calendar \
            --enable-intl \
            --enable-mbstring \
            --enable-cli \
            --enable-soap \
            --disable-cgi \
            --disable-debug \
            --disable-phpdbg-debug \
            --prefix="/usr/local/bin" \
            --with-libdir=lib64 \
            --with-libdir=$libsdir/sqlite/sqlite-autoconf-3510100 \
            --with-libdir=$libsdir/libxml/libxml2-2.15.1/include

     make -j $(nproc)

     make install

     make test

     cd "$libsdir/maria/server-mariadb-12.3.1/"

     apt install -y lsb-release devscripts dh-exec dh-package-notes cmake cracklib-runtime default-jdk flex gdb libaio-dev libboost-atomic-dev libboost-chrono-dev libboost-date-time-dev libboost-dev libboost-filesystem-dev libboost-regex-dev libboost-system-dev libboost-thread-dev libbz2-dev libcrack2-dev libcurl4-gnutls-dev libedit-dev libedit-dev libfmt-dev libjemalloc-dev libjudy-dev libkrb5-dev liblz4-dev liblzo2-dev libnuma-dev libpam0g-dev libsnappy-dev libssl-dev libssl-dev liburing-dev libzstd-dev unixodbc-dev libmariadb-dev-compat python3-mariadb-connector

     git submodule update --init --recursive

     /bin/bash debian/autobake-deb.sh

     dpkg -i 1:12.3.1+maria~debsid.deb

     cd "$libsdir/memc/memcached-1.6.40"

     apt install autotools-dev automake libevent-dev

     cat <<EOF >> timespec.patch
--- a/util.c    2026-02-18 09:17:05.859130661 +0000
+++ b/util.c    2025-10-22 04:59:10.000000000 +0000
@@ -281,7 +281,6 @@
 }
 #endif

-#ifndef _STRUCT_TIMESPEC
 // adds ts2 to ts1
 #define NSEC_PER_SEC 1000000000
 void mc_timespec_add(struct timespec *ts1,
@@ -293,4 +292,4 @@
         ts1->tv_nsec -= NSEC_PER_SEC;
     }
 }
-#endif
+
--- a/util.h    2026-02-18 09:17:10.159130661 +0000
+++ b/util.h    2025-10-22 04:59:10.000000000 +0000
@@ -46,6 +46,4 @@
 /* Some common timepsec functions.
  */

-#ifndef _STRUCT_TIMESPEC
 void mc_timespec_add(struct timespec *ts1, struct timespec *ts2);
-#endif
EOF

     patch timespec.patch

     make clean

     ./configure --prefix=/usr/local/bin \
                 --enable-static

     make -j $(nproc)

     make install

     cd "$libsdir/httpd/httpd-2.4.66"

     apt install -y libaprutil1-dev libpcre2-dev libpcre2-32-0 pcre2-utils python3-pcre2 libpcre2-posix3

     make clean

     ./configure --prefix=/usr/local/bin \
                 --enable-rewrite \
                 --enable-unixd \
                 --enable-rewrite \
                 --enable-curl \
                 --enable-proxy \
                 --enable-proxy-fcgi \
                 --enable-heartbeat \
                 --enable-heartbeatmonitor \
                 --host=x86_64 \
                 --target=aarch64 \
                 --with-curl=$libsdir/curl/curl-8.17.0 \
                 --with-libxml2=$libsdir/libxml/libxml2-2.15.1 \
                 --with-pcre=/usr/bin/pcre2-config

     make -j $(nproc)

     make install

     cd "$libsdir/httpdfcgi/mod_fcgid-2.3.9"

     ./configure

     make

     make install

fi

php -v

php-fpm -v

memcached -V

exit 0

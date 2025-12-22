#!/bin/bash
#
# udocker run --entrypoint="/usr/bin/fish" --volume="/data/data/com.termux/files/home/git/fado/:/var/www/html" debian:forky
# cd /var/www/html/docker
# ./compilephp.sh true true true 1F
# ./compilephp.sh $down_libs $extract_libs $install_pkgs $pre_compile_libs
#
# ubuntu:25.04 debian:forky kalilinux/kali-rolling:latest
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
   apt install -y build-essential autoconf libtool binutils bison re2c wget2 tar gnulib gcc-15 libstdc++-15-dev libgcc-15-dev libstdc++6 libc6-dev pkgconf python3-icu libnpth0-dev libgnutls28-dev libpsl-dev libtestsweeper-dev libpthreadpool-dev libselinux-dev libapparmor-dev libsystemd-dev libacl1-dev python3-pylibacl
fi

if [ "$down" = "true" ]; then
   rm -r "$libsdir"
   mkdir "$libsdir"
   cd "$libsdir"
   wget2 -O zlib.tar.gz https://zlib.net/zlib-1.3.1.tar.gz
   wget2 -O oniguruma.tar.gz https://github.com/kkos/oniguruma/releases/download/v6.9.10/onig-6.9.10.tar.gz
   wget2 -O icu.tar.gz https://github.com/unicode-org/icu/archive/refs/tags/release-78.1.tar.gz
   wget2 -O libxml.tar.xz https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz
   wget2 -O openssl.tar.gz https://github.com/openssl/openssl/releases/download/openssl-3.5.1/openssl-3.5.1.tar.gz
   wget2 -O php.tar.bz2 https://www.php.net/distributions/php-8.5.1.tar.bz2
   wget2 -O gettext.tar.gz https://ftp.gnu.org/pub/gnu/gettext/gettext-0.26.tar.gz
   wget2 -O curl.tar.gz https://curl.se/download/curl-8.15.0.tar.gz
   wget2 -O sqlite.tar.gz https://sqlite.org/2025/sqlite-autoconf-3510100.tar.gz
   wget2 -O ntp.tar.gz https://downloads.nwtime.org/ntp/ntp-4.2.8p18.tar.gz
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
   cp "$libsdir/icu.tar.gz" icu/
   cd icu
   tar xvfz icu.tar.gz
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
   mkdir sqlite
   cp "$libsdir/sqlite.tar.gz" sqlite/
   cd sqlite/
   tar xvfz sqlite.tar.gz
   cd "$libsdir/extr"
   rm -r php/
   mkdir php
   cp "$libsdir/php.tar.bz2" php/
   cd php/
   tar xvf php.tar.bz2
   cd php-8.5.1/
elif [ true ]; then
   cd "$libsdir/extr/php/php-8.5.1/"
fi

libsdir="$libsdir/extr"

export SYSTEMD_LIBS=/usr/lib/systemd
export PKG_CONFIG_PATH=/usr/lib/pkgconfig
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/openssl/openssl-3.5.1/libcrypto.pc
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/libxml/libxml2-2.15.1
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/sqlite/sqlite-autoconf-3510100
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/zlib/zlib-1.3.1/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/oniguruma/onig-6.9.10/src
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$libsdir/icu/icu-release-78.1/icu4c/source/lib
export LIBXML_CFLAGS=-I$libsdir/libxml/libxml2-2.15.1/include
export LIBXML_LIBS=-L$libsdir/libxml/libxml2-2.15.1
export OPENSSL_CFLAGS=-I$libsdir/openssl/openssl-3.5.1/include
export OPENSSL_LIBS=-L$libsdir/openssl/openssl-3.5.1/lib
export PHP_SQLITE_CFLAGS=-I$libsdir/sqlite/sqlite-autoconf-3510100
export PHP_SQLITE_LIBS=-L$libsdir/sqlite/sqlite-autoconf-3510100
export ICU_CFLAGS=-I$libsdir/icu/icu-release-78.1/icu4c/source/common
export ICU_LIBS=-L$libsdir/icu/icu-release-78.1/icu4c/source/lib
export ONIG_CFLAGS=-I$libsdir/oniguruma/onig-6.9.10/src
export ONIG_LIBS=-L$libsdir/oniguruma/onig-6.9.10/src
export ZLIB_CFLAGS=-I$libsdir/zlib/zlib-1.3.1/include
export ZLIB_LIBS=-L$libsdir/zlib/zlib-1.3.1/lib
export INTL_CFLAGS=-I$libsdir/gettext/gettext-0.26/include
export INTL_LIBS=-L$libsdir/gettext/gettext-0.26/lib
export CURL_CFLAGS=-I$libsdir/curl/curl-8.15.0/include
export CURL_LIBS=-L$libsdir/curl/curl-8.15.0/lib
export SQLITE_LIBS=-L$libsdir/sqlite/sqlite-autoconf-3510100
export SQLITE_CFLAGS=-I$libsdir/sqlite/sqlite-autoconf-3510100
export NTP_LIBS=-L$libsdir/ntp/ntp-4.2.8p18/lib
export NTP_CFLAGS=-I$libsdir/ntp/ntp-4.2.8p18/include
export LDFLAGS="-L/lib -L/usr/lib $LIBXML_LIBS $OPENSSL_LIBS $ICU_LIBS $ONIG_LIBS $ZLIB_LIBS $INTL_LIBS $CURL_LIBS $SQLITE_LIBS $NTP_LIBS"
export LD_LIBRARY_PATH="/lib:/usr/lib:$PKG_CONFIG_PATH"
export PHP_INTL_STDCXX=17
export ICU_CXXFLAGS="$ICU_CXXFLAGS -std=c++17 -shared-libgcc -shared-libstdc++"
export PHP_CXX_COMPILE_STDCXX=11
export CXXFLAGS="$CXXFLAGS -shared-libgcc -shared-libstdc++ -std=c++11"

if [ "$op" = "true" ]; then

    cd "$libsdir/libxml/libxml2-2.15.1/"

    ./configure --without-debug --with-zlib --with-gnu-ld

    make -j $(nproc)

    cd "$libsdir/openssl/openssl-3.5.1/"

    ./Configure

    make -j $(nproc)

    cd "$libsdir/zlib/zlib-1.3.1/"

    ./configure --with-gnu-ld

    make -j $(nproc)

    cd "$libsdir/ntp/ntp-4.2.8p18"

    ./configure --with-crypto=openssl --with-openssl-libdir=$libsdir/openssl/openssl-3.5.1 --with-openssl-incdir=$libsdir/openssl/openssl-3.5.1/include --with-gnu-ld

    make -j $(nproc)

    cd "$libsdir/gettext/gettext-0.26"

    ./configure

    make -j $(nproc)

    cd "$libsdir/icu/icu-release-78.1/icu4c/source/"

    ./configure

    make -j $(nproc)

    cd "$libsdir/curl/curl-8.15.0/"

    ./configure --with-gnutls --without-python --with-gnu-ld

    make -j $(nproc)

    cd "$libsdir/oniguruma/onig-6.9.10/"

    autoreconf -vfi

    ./configure --with-gnu-ld

    make -j $(nproc)

    cd "$libsdir/sqlite/sqlite-autoconf-3510100"

    ./configure --with-icu-ldflags=$ICU_LIBS --with-icu-cflags=$ICU_CFLAGS --icu-collations

    make -j $(nproc)

fi

if [ true ]; then

    cd "$libsdir/php/php-8.5.1/"

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
            --with-mysql-sock=/var/mysql/mysql.sock \
            --with-libxml=shared \
            --with-gnu-ld \
            --enable-calendar \
            --enable-intl \
            --enable-mbstring \
            --enable-cli \
            --enable-soap \
            --disable-cgi \
            --disable-phpdbg \
            --with-libdir=lib64 \
#            --enable-phpdbg-debug \
#            --enable-debug

     make -j $(nproc)

     make install
fi

php -v

php-fpm -v

exit 0

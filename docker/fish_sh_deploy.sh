#!/bin/bash
#
# udocker run --entrypoint="/bin/bash -f /var/www/html/docker/fish_sh_deploy.sh" --volume="/data/data/com.termux/files/home/github/fado/:/var/www/html/" debian:forky

export PS1='\[\033[1;34m\]\t \[\033[0;36m\]\H \[\033[0;32m\]\w\[\033[0;35m\]> '
is=$( which fish )
if [[ $is != "" ]]; then
    /bin/fish
    exit 0
fi
apt update
apt upgrade -y
apt install -y fish
/bin/bash -f /var/www/html/docker/deploy-forky.sh true
/bin/fish
exit 0

#!/bin/bash
#udocker run --entrypoint="/bin/bash -f /var/www/html/docker/fish_sh_deploy.sh" --volume="/data/data/com.termux/files/home/github/fado/:/var/www/html/" debian:forky
bin=$(which fish)
is=$( which fish  | wc -l | wc -l )
if [ $is -eq "1" ]; then
    /bin/fish
    exit 0
fi
apt update
apt upgrade -y
apt install -y fish
/bin/fish
exit 0

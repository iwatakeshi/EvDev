#!/bin/bash

# Update packages and Upgrade system
apt-get update -y && apt-get upgrade -y

## Install AMP
apt install -y apache2 mysql-server
apt install -y php7.2 libapache2-mod-php7.2 php7.2-mbstring php7.2-xmlrpc php7.2-soap php7.2-gd php7.2-xml php7.2-cli php7.2-zip
apt install unzip
printf "memory_limit = 256M\nupload_max_filesize = 64M\ncgi.fix_pathinfo=0" >> /etc/php/7.2/apache2/php.ini

EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
exit $RESULT
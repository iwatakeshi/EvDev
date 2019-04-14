#!/bin/bash

apt-get update
apt-get -y install git build-essential curl wget gnupg2 xz-utils openssl net-tools
# Install Homebrew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
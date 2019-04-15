#!/bin/bash
sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
apt-get update && apt-get install -y git build-essential curl wget gnupg2 xz-utils openssl net-tools file apt-transport-https checkinstall && apt-get build-dep imagemagick -y
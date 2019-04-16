#!/bin/bash

export USER=user

sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
echo "export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH" >> ~/.bash_profile
echo "export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH" >> ~/.profile
. ~/.bash_profile
echo $PATH
#!/bin/bash

# Install Python via pyenv
brew update && brew install pyenv
pyenv install 2.7.16
pyenv install 3.7.3
pyenv global 3.7.3
pip3 install python-language-server
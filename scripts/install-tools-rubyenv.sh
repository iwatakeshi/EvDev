#!/bin/bash

# Install Ruby via rubyenv
brew update && brew install rubyenv
rubyenv init
exec "$SHELL"
rubyenv install 2.6.2
rubyenv global 2.6.2
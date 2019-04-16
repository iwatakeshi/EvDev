#!/bin/bash

# Install Ruby via rubyenv
brew update && brew install rbenv
RUBY_CONFIGURE_OPTS=--with-readline-dir="$(brew --prefix readline)" rbenv install -v 2.6.2
rbenv global 2.6.2
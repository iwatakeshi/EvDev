#!/bin/bash

# Install Swift via swifenv
brew update && brew install swiftenv
swiftenv init
exec "$SHELL"
swiftenv install 5.0
swifenv global 5.0
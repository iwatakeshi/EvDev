#!/bin/bash

# Install Swift via swifenv
brew update && brew install kylef/formulae/swiftenv
swiftenv install 4.1
swifenv global 4.1
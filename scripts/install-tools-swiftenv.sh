#!/bin/bash

# Install Swift via swifenv
brew update && brew install kylef/formulae/swiftenv
swiftenv install 5.0
swifenv global 5.0
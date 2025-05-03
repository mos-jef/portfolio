#!/bin/bash
# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"
flutter --version
flutter doctor

# Build the web app
flutter build web --release
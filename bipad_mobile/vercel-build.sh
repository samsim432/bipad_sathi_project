#!/bin/bash
if [ -d "flutter" ]; then
  cd flutter
  git pull
  cd ..
else
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable
fi
export PATH="$PATH:`pwd`/flutter/bin"
flutter config --enable-web
flutter pub get
flutter build web --release --no-tree-shake-icons

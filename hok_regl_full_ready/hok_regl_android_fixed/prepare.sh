#!/bin/bash
# Prepare Flutter project for building on a fresh system.
# If android/ios folders missing, this will create platforms using `flutter create .`.
if [ ! -d "android" ] || [ ! -d "ios" ]; then
  echo "Creating platform folders (flutter create .) ..."
  flutter create .
fi
echo "Running flutter pub get ..."
flutter pub get
echo "Done. Now you can run 'flutter build apk --release' or 'flutter run'."
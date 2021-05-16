#!/usr/bin/env bash
dir=./

cd $dir
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
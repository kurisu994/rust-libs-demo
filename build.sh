#!/bin/bash

cargo clean

mkdir -p dist

rm -rf ./dist/*
# 进一步使用nightly版本编译进行编译优化
#cargo +nightly build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --target aarch64-linux-android  --target armv7-linux-androideabi --release
cargo build --target aarch64-linux-android  --target armv7-linux-androideabi --release
if [ $? -eq 0 ]; then
  mkdir -p ./dist/armeabi-v7a
  mkdir -p ./dist/arm64-v8a
  mv ./target/armv7-linux-androideabi/release/librust_libs_demo.so ./dist/armeabi-v7a/librust_libs_demo.so
  mv ./target/aarch64-linux-android/release/librust_libs_demo.so ./dist/arm64-v8a/librust_libs_demo.so
fi

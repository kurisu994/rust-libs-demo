#!/bin/bash

cargo clean

mkdir -p dist

rm -rf ./dist/*
# 进一步使用nightly版本编译进行编译优化
#cargo +nightly build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --target aarch64-linux-android  --target armv7-linux-androideabi --release
cargo build --target aarch64-linux-android  --target armv7-linux-androideabi --release
if [ $? -eq 0 ]; then
  mkdir -p ./dist/android/armeabi-v7a
  mkdir -p ./dist/android/arm64-v8a
  cp ./target/armv7-linux-androideabi/release/librust_libs_demo.so ./dist/android/armeabi-v7a/librust_libs_demo.so
  cp ./target/aarch64-linux-android/release/librust_libs_demo.so ./dist/android/arm64-v8a/librust_libs_demo.so
fi


# 编译ios版本的静态库
#cargo +nightly build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --all-features --target aarch64-apple-ios --target x86_64-apple-ios --release
cargo lipo --all-features --release --targets x86_64-apple-ios aarch64-apple-ios

if [ $? -eq 0 ]; then
  mkdir -p ./dist/ios/x86
  mkdir -p ./dist/ios/aarch64
  mkdir -p ./dist/ios/universal

#  lipo -create ./target/x86_64-apple-ios/release/librust_libs_demo.a ./target/aarch64-apple-ios/release/librust_libs_demo.a -output ./dist/ios/universal/librust_libs_demo.a

  cp ./target/x86_64-apple-ios/release/librust_libs_demo.a ./dist/ios/x86/librust_libs_demo.a
  cp ./target/aarch64-apple-ios/release/librust_libs_demo.a ./dist/ios/aarch64/librust_libs_demo.a
  # 使用lipo手动合并x86和arm64两个平台库的话需要注释掉下面这句
  cp ./target/universal/release/librust_libs_demo.a ./dist/ios/universal/librust_libs_demo.a

  # 生成头文件
  cbindgen ./src/ios.rs -l c --output dist/ios/librust.h
fi

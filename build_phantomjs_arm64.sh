#!/bin/bash
set -x
wget -c http://releases.llvm.org/3.8.0/clang+llvm-3.8.0-aarch64-linux-gnu.tar.xz
tar -xf clang+llvm-3.8.0-aarch64-linux-gnu.tar.xz
export CLANG_DIR=$(pwd)/clang+llvm-3.8.0-aarch64-linux-gnu/bin/
git clone https://github.com/ariya/phantomjs.git
cd phantomjs
export PHANTOMJSDIR=$(pwd)
git checkout 2.1.1
git submodule init
git submodule update
sudo sed -i~orig -e 's/# deb-src/deb-src/' /etc/apt/sources.list
sudo apt-get update
apt-get source openssl
cd openssl-1.0.*
./Configure --prefix=/usr --openssldir=/etc/ssl --libdir=lib ${OPENSSL_FLAGS} linux-generic64
make -j4 depend
make -j4
sudo make install_sw
cd $PHANTOMJSDIR
apt-get source icu
cd icu-5*/source
./configure --prefix=/usr --enable-static --disable-shared
make -j4
sudo make install
cd $PHANTOMJSDIR
export CC=$CLANG_DIR/clang
export CXX=$CLANG_DIR/clang++
python build.py  --confirm --release --qt-config="-no-pkg-config" --git-clean-qtbase --git-clean-qtwebkit

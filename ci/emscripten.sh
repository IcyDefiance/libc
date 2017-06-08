# Copyright 2017 The Rust Project Developers. See the COPYRIGHT
# file at the top-level directory of this distribution and at
# http://rust-lang.org/COPYRIGHT.
#
# Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
# http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
# <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
# option. This file may not be copied, modified, or distributed
# except according to those terms.

set -ex

cd /
curl -L https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz | \
    tar -xz

cd /emsdk-portable
./emsdk update
./emsdk install sdk-1.37.13-64bit
./emsdk activate sdk-1.37.13-64bit

# Compile and cache libc
source ./emsdk_env.sh
echo "main(){}" > a.c
HOME=/emsdk-portable/ emcc a.c
HOME=/emsdk-portable/ emcc -s BINARYEN=1 a.c
rm -f a.*

# Make emsdk usable by any user
cp /root/.emscripten /emsdk-portable
chmod a+rxw -R /emsdk-portable

# node 8 is required to run wasm
cd /
curl -L https://nodejs.org/dist/v8.0.0/node-v8.0.0-linux-x64.tar.xz | \
    tar -xJ

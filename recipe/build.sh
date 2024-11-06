#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [ $(uname) = Darwin ] ; then
  export RUSTFLAGS="-C link-args=-Wl,-rpath,${PREFIX}/lib"
  export BUILD_ARGS=""
else
  export RUSTFLAGS="-C link-arg=-Wl,-rpath-link,${PREFIX}/lib -L${PREFIX}/lib"
  export BUILD_ARGS="--features unwind"
fi

# build statically linked binary with Rust
cargo install $BUILD_ARGS --locked --root "$PREFIX" --path .

# strip debug symbols
"$STRIP" "$PREFIX/bin/py-spy"

# remove extra build file
rm -f "${PREFIX}/.crates.toml"

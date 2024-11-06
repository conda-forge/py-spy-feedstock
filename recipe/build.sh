#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ "${target_platform}" == osx-* ]]; then
  export RUSTFLAGS="-C link-args=-Wl,-rpath,${PREFIX}/lib"
else
  export RUSTFLAGS="-C link-arg=-Wl,-rpath-link,${PREFIX}/lib -L${PREFIX}/lib"
fi

if [[ "${target_platform}" =~ ^(linux-64|win-64)$ ]]; then
  export BUILD_ARGS="--features unwind"
else
  export BUILD_ARGS=""
fi

# build statically linked binary with Rust
cargo install $BUILD_ARGS --locked --root "$PREFIX" --path .

# strip debug symbols
"$STRIP" "$PREFIX/bin/py-spy"

# remove extra build file
rm -f "${PREFIX}/.crates.toml"

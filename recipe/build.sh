#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [ $(uname) = Darwin ] ; then
  export RUSTFLAGS="-C link-args=-Wl,-rpath,${PREFIX}/lib"
else
  export RUSTFLAGS="-C link-arg=-Wl,-rpath-link,${PREFIX}/lib -C link-arg=-L${PREFIX}"
fi

# build statically linked binary with Rust
cargo install --locked --root "$PREFIX" --path .

# strip debug symbols
"$STRIP" "$PREFIX/bin/py-spy"

# remove extra build file
rm -f "${PREFIX}/.crates.toml"

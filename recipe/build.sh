#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

if [[ "${target_platform}" == osx-* ]]; then
  export RUSTFLAGS="-C link-args=-Wl,-rpath,${PREFIX}/lib"
else
  export RUSTFLAGS="-C link-arg=-Wl,-rpath-link,${PREFIX}/lib -L${PREFIX}/lib"
fi

if [[ "${target_platform}" == "linux-64" ]]; then
  export BUILD_ARGS="--features unwind"
else
  export BUILD_ARGS=""
fi

# build statically linked binary with Rust
cargo install $BUILD_ARGS --no-track --locked --root "$PREFIX" --path .

export LANG=C
export LC_ALL=C
./nix develop \
        --impure \
        --accept-flake-config \
        --extra-experimental-features 'nix-command flakes' \
        .

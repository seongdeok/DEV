curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > ./nix
chmod +x ./nix
ln -s ${PWD}/../nvim ${PWD}/.config-devshell/nvim

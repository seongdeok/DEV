curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m) > ./nix
chmod +x ./nix
ln -s ${PWD}/../nvim ${PWD}/.config-devshell/nvim
mkdir -p ${PWD}/.config-devshell/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ${PWD}/.config-devshell/tmux/plugins/tpm

{
  description = "DevShell with zsh, starship, and rich CLI tools";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        configDir = "$PWD/.config-devshell";
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Shell + Prompt
            zsh
            starship
            zsh-autosuggestions
            zsh-syntax-highlighting

            # Terminal utilities
            fzf 
            thefuck
            zoxide

            # File search/view/navigation
            fd
            bat
            eza
            tree
            ripgrep
            yazi

            # Dev tools
            neovim
            tmux
            git
            curl
            wget
            unzip
            jq

            # System monitoring
            htop
            bottom  # `btm`
            btop
            duf
            dust
            procs
            neofetch

            # Info/help
            tldr
            dog
            navi
          ];

          shellHook = ''
            export XDG_CONFIG_HOME=${configDir}
            export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
            # zsh plugin 경로 export
            export ZSH_AUTOSUGGESTIONS_PATH=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            export ZSH_SYNTAX_HIGHLIGHTING_PATH=${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

            # Use isolated zshrc
            export ZDOTDIR=${configDir}/zsh 
            exec zsh
          '';
        };
      });
}

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
        fzfPath = "${pkgs.fzf}/share/fzf";
        zshPath = "${pkgs.zsh}/bin/zsh";

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
            ueberzugpp

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
            export XDG_DATA_HOME=${configDir}/local/share
            export XDG_CACHE_HOME=${configDir}/cache
            export XDG_STATE_HOME=${configDir}/state

            export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
            # zsh plugin 경로 export
            export ZSH_AUTOSUGGESTIONS_PATH=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            export ZSH_SYNTAX_HIGHLIGHTING_PATH=${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          # make tmux.conf
            tmpl="$PWD/.config-devshell/tmux/tmux.conf.template"
            out="$PWD/.config-devshell/tmux/tmux.conf"
            [ -f "$out" ] && rm -f "$out"
            sed "s|{{ZSH_PATH}}|${zshPath}|" "$tmpl" > "$out"

          # Use isolated zshrc
            export ZDOTDIR=${configDir}/zsh 
            export FZF_KEYBINDINGS_PATH="${fzfPath}/key-bindings.zsh"
            export FZF_COMPLETION_PATH="${fzfPath}/completion.zsh"
            export SHELL=$(which zsh)
            export TERM="xterm-256color"
            export LANG=en_US.UTF-8
            export LC_ALL=en_US.UTF-8
            exec zsh
          '';
        };
      });
}


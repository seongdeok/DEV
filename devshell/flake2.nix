{
  description = "Node.js development environment with zsh";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
        cfgDir = "$PWD/.config-devshell";
        zshBin = "${pkgs.zsh}/bin/zsh";
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs_20
          zsh
# ─── Shell & Prompt ───
            zsh
            starship
            zsh-autosuggestions
            zsh-syntax-highlighting

            # ─── Terminal Utilities ───
            fzf
            zoxide

            # ─── File Search / Navigation ───
            fd
            bat
            eza
            tree
            ripgrep
            yazi

            # ─── Dev Tools ───
            neovim
            tmux
            git
            curl
            wget
            unzip
            jq
            ueberzugpp

            # ─── System Monitoring ───
            htop
            bottom    # btm
            btop
            duf
            dust
            procs
            neofetch

            # ─── Info / Help ───
            tldr
            dog
            navi


            # ─── Python3 + pip + venv + requests + rich ───
            (python3.withPackages (ps: with ps; [
              ps.pip
              ps.virtualenv
              ps.requests
              ps.rich
            ]))

            # ─── GNU tar (버전 출력용) ───
            gnutar

            # ─── bsdtar from libarchive (Mason unpack용) ───
            libarchive
     glibcLocales
 glibc
  stdenv.cc.cc.lib
        ];

        # 환경변수 설정
        SHELL = "${pkgs.zsh}/bin/zsh";
        LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";

        shellHook = ''
          echo "🚀 Node.js development environment"
          echo "📦 Node: $(node --version)"
          echo "📦 npm: $(npm --version)"
          echo "🐚 Shell: zsh"

            export TERM=xterm-256color
            # ────────────────────────────────────────────────────────────
            # 1) XDG 기본 경로 설정
            export XDG_CONFIG_HOME=${cfgDir}
            export XDG_DATA_HOME=${cfgDir}/local/share
            export XDG_CACHE_HOME=${cfgDir}/cache
            export XDG_STATE_HOME=${cfgDir}/state

# 3) tmux.conf 템플릿 → 실제 파일
            tmpl="$PWD/.config-devshell/tmux/tmux.conf.template"
            out="$PWD/.config-devshell/tmux/tmux.conf"
            [ -f "$out" ] && rm -f "$out"
            sed "s|{{ZSH_PATH}}|${zshBin}|" "$tmpl" > "$out"

export ZSH_AUTOSUGGESTIONS_PATH=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            export ZSH_SYNTAX_HIGHLIGHTING_PATH=${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
            export FZF_KEYBINDINGS_PATH=${pkgs.fzf}/share/fzf/key-bindings.zsh
            export FZF_COMPLETION_PATH=${pkgs.fzf}/share/fzf/completion.zsh
            export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline --color=bg+:#1e1e2e,fg+:#f5e0dc,header:#f38ba8,pointer:#89b4fa"
            # 8) zshrc 위치 설정
            export ZDOTDIR=$XDG_CONFIG_HOME/zsh


          # zsh로 전환
          exec ${pkgs.zsh}/bin/zsh
        '';
      };
    };
}

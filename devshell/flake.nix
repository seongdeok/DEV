{
  description = "DevShell with zsh, starship, Neovim, Mason and Node/Python";

  inputs = {
    nixpkgs     = { url = "github:NixOS/nixpkgs/nixos-24.05"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs   = import nixpkgs { inherit system; };
        cfgDir = "$PWD/.config-devshell";
        zshBin = "${pkgs.zsh}/bin/zsh";
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # ─── Shell & Prompt ───
            zsh
            starship
            zsh-autosuggestions
            zsh-syntax-highlighting

            # ─── Terminal Utilities ───
            fzf
            thefuck
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

            # ─── Node.js 18 LTS (npm 9.x 내장) ───
            nodejs_18
            nodePackages.npm      # ← “npm” 바이너리를 직접 추가

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
          ];

          shellHook = ''
            export TERM=xterm-256color
            # ────────────────────────────────────────────────────────────
            # 1) XDG 기본 경로 설정
            export XDG_CONFIG_HOME=${cfgDir}
            export XDG_DATA_HOME=${cfgDir}/local/share
            export XDG_CACHE_HOME=${cfgDir}/cache
            export XDG_STATE_HOME=${cfgDir}/state

            # 2) 기본 locale
            export LANG=C.UTF-8
            export LC_ALL=C.UTF-8

            # 3) tmux.conf 템플릿 → 실제 파일
            tmpl="$PWD/.config-devshell/tmux/tmux.conf.template"
            out="$PWD/.config-devshell/tmux/tmux.conf"
            [ -f "$out" ] && rm -f "$out"
            sed "s|{{ZSH_PATH}}|${zshBin}|" "$tmpl" > "$out"

            # 4) .nix-shims 디렉터리 초기화
            rm -rf .nix-shims
            mkdir -p .nix-shims

            # 5) python3 / node / tar 래퍼
            #    (– ‘npm’ 대신, nodePackages.npm 으로 경로 문제 해결)
            ln -s "$(which python3)" .nix-shims/python
            ln -s "$(which node)"    .nix-shims/node

            #    GNU tar 버전 확인 시 gnutar, 그 외는 bsdtar 사용
            cat > .nix-shims/tar <<EOF
#!/usr/bin/env bash
if [ "\$1" = "--version" ] || [ "\$1" = "-V" ]; then
  exec "${pkgs.gnutar}/bin/tar" "\$@"
else
  exec "${pkgs.libarchive}/bin/bsdtar" "\$@"
fi
EOF
            chmod +x .nix-shims/tar

            # 6) .nix-shims 경로를 PATH 맨 앞에 추가
            export PATH="$PWD/.nix-shims:$PATH"

            # 7) zsh
            export ZSH_AUTOSUGGESTIONS_PATH=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            export ZSH_SYNTAX_HIGHLIGHTING_PATH=${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
            export FZF_KEYBINDINGS_PATH=${pkgs.fzf}/share/fzf/key-bindings.zsh
            export FZF_COMPLETION_PATH=${pkgs.fzf}/share/fzf/completion.zsh
            export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline --color=bg+:#1e1e2e,fg+:#f5e0dc,header:#f38ba8,pointer:#89b4fa"
            # 8) zshrc 위치 설정
            export ZDOTDIR=$XDG_CONFIG_HOME/zsh

            # 9) zsh로 진입
            exec zsh
          '';
        };
      });
}

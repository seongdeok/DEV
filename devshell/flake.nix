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
          # ─── 빌드에 필요한 패키지 ───
          packages = with pkgs; [
            # Shell & Prompt
            zsh
            starship
            zsh-autosuggestions
            zsh-syntax-highlighting

            # Terminal Utilities
            fzf
            thefuck
            zoxide

            # File Search / Navigation
            fd
            bat
            eza
            tree
            ripgrep
            yazi

            # Dev Tools
            neovim
            tmux
            git
            curl
            wget
            unzip
            jq
            ueberzugpp

            # System Monitoring
            htop
            bottom    # btm
            btop
            duf
            dust
            procs
            neofetch

            # Info / Help
            tldr
            dog
            navi

            # Node.js 18 LTS (npm 9.x 내장)
            nodejs_18
            gnutar
            # Python3 + pip + venv + requests + rich
            (python3.withPackages (ps: with ps; [
              ps.pip
              ps.virtualenv
              ps.requests
              ps.rich
            ]))
          ];

          # ─── 쉘에 진입할 때 실행되는 설정 ───
          shellHook = ''
            # 1) XDG 기본 경로
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

            # 4) npm 래퍼 (깨진 npm 스크립트 우회)
            rm -rf .nix-shims
            mkdir -p .nix-shims
            NPM_CLI=$(dirname "$(which node)")/../lib/node_modules/npm/bin/npm-cli.js
            cat > .nix-shims/npm <<'EOF'
#!/usr/bin/env bash
exec node "$NPM_CLI" "$@"
EOF
            chmod +x .nix-shims/npm

            # 5) python / node shim
            ln -s "$(which python3)" .nix-shims/python
            ln -s "$(which node)"    .nix-shims/node
            ln -s "$(which tar)"     .nix-shims/tar

            # 6) shim 경로 우선
            export PATH="$PWD/.nix-shims:$PATH"

            # 7) 편의 alias
            alias vi=nvim

            export ZDOTDIR=$XDG_CONFIG_HOME/zsh

            # 8) zsh로 교체
            exec zsh
          '';
        };
      });
}

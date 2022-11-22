{ utils, dfconf }:
utils.mkDefs {
  homeDefs = ({ config, pkgs, ... }:
    let inherit (pkgs.nodePackages) prettier-plugin-svelte prettier-plugin-toml; in
    {
      xdg.configFile.nvim = {
        recursive = true;
        source = with pkgs; substituteAllRec {
          src = ./nvim;
          nodejs16 = pkgs.nodejs-16_x;
          prettierSvelte = prettier-plugin-svelte;
          prettierToml = prettier-plugin-toml;
          repoDir = dfconf.repoDir + "/neovim/nvim";
          inherit (pkgs) gcc;
          inherit (dfconf) fontsize graphical;
        };
      };

      home = {
        packages = with pkgs; [
          neovim

          #Telescope
          ripgrep
          ripgrep-all

          #Graphical env
          neovide

          #Clipboard integration
          xclip
          wl-clipboard

          #Python and JS integration
          python3Packages.pynvim
          nodePackages.neovim

          #LuaJIT and luarocks
          luajit
          luajitPackages.luarocks

          #LSPs
          nodePackages.bash-language-server
          nodePackages.yaml-language-server
          nodePackages.vscode-langservers-extracted
          nodePackages.pyright
          nodePackages.tailwindcss-language-server
          nodePackages.volar
          nodePackages.typescript-language-server
          nodePackages.svelte-language-server
          sumneko-lua-language-server
          nil
          rust-analyzer

          #Linters
          clippy
          shellcheck

          #Formatters
          stylua
          nixpkgs-fmt
          nodePackages.prettier
          rustfmt
          beautysh
        ];

        sessionVariables = {
          NEOVIDE_MULTIGRID = "true";
        };
      };
    });
}

{ dfconf, extra, lib, pkgs, ... }:
extra.userDefinitions {
  xdg.configFile.nvim = {
    recursive = true;
    source = with pkgs; substituteAllRec {
      src = ./nvim;
      nodejs16 = pkgs.nodejs-16_x;
      inherit (pkgs) gcc;
      inherit (dfconf) fontsize graphical repoDir;
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
      NEOVIDE_MULTIGRID = true;
    };
  };
}

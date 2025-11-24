{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
  ufo =
    cmd:
    mkRaw ''
      function()
        return require("ufo").${cmd}()
      end
    '';

  scBuiltin =
    cmd:
    mkRaw ''
      function(args)
        return require("statuscol.builtin").${cmd}(args)
      end
    '';
in
{

  plugins = {
    nvim-ufo = {
      enable = true;
      settings.fold_virt_text_handler = ''
        function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = (" 󰁂 %d "):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              -- str width returned from truncate() may less than 2nd argument, need padding
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "MoreMsg" })
          return newVirtText
        end
      '';
    };

    statuscol = {
      enable = true;
      settings = {
        relculright = true;
        segments = [
          {
            text = [ "%s" ];
            click = "v:lua.ScSa";
          }
          {
            text = [ (scBuiltin "foldfunc") ];
            click = "v:lua.ScFa";
          }
          {
            text = [
              (scBuiltin "lnumfunc")
              " "
            ];
            condition = [
              true
              (scBuiltin "not_empty")
            ];
            click = "v:lua.ScLa";
          }
        ];
      };
    };

  };

  opts = {
    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "zM";
      action = ufo "closeAllFolds";
      options.desc = "Close all folds";
    }
    {
      mode = "n";
      key = "zR";
      action = ufo "openAllFolds";
      options.desc = "Open all folds";
    }
  ];
}

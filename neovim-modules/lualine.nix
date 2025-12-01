{ lib, ... }:
let
  inherit (lib.nixvim) listToUnkeyedAttrs mkRaw;

  macroRecording = mkRaw ''
    function()
      local recording_register = vim.fn.reg_recording()
      if recording_register == "" then
        return ""
      else
        return "Recording @" .. recording_register
      end
    end
  '';

  diagnostics = listToUnkeyedAttrs [ "diagnostics" ] // {
    sources = [ "nvim_diagnostic" ];
    sections = [
      "error"
      "warn"
    ];
    symbols = {
      error = " ";
      warn = " ";
    };
    always_visible = true;
  };

  filename = listToUnkeyedAttrs [ "filename" ] // {
    path = 4;
    shorting_target = 15;
  };

  hideInWidth = mkRaw ''
    function()
      return vim.fn.winwidth(0) > 80
    end
  '';

  diffSource = mkRaw ''
    function()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed
        }
      end
    end
  '';

  diff = listToUnkeyedAttrs [ "diff" ] // {
    symbols = {
      added = " ";
      modified = " ";
      removed = " ";
    };
    cond = hideInWidth;
    source = diffSource;
  };

  spaces = mkRaw ''
    function()
      return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
    end
  '';

in
{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
        component_separators = {
          left = "";
          right = "";
        };
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ (listToUnkeyedAttrs [ "b:gitsigns_head" ] // { icon = ""; }) ];
        lualine_c = [
          macroRecording
          diagnostics
          filename
        ];
        lualine_x = [
          diff
          spaces
          "encoding"
          "filetype"
        ];
        lualine_y = [ "location" ];
        lualine_z = [ "progress" ];
      };
    };
  };
}

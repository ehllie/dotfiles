{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    friendly-snippets.enable = true;
    blink-cmp-copilot.enable = true;
    copilot-lua = {
      enable = true;
      settings.filetypes = {
        oil = false;
      };
    };
    lspkind = {
      enable = true;
      cmp.enable = false;
    };
    blink-cmp = {
      enable = true;
      settings = {
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "copilot"
          ];
          providers.copilot = {
            name = "copilot";
            module = "blink-cmp-copilot";
            score_offset = 100;
            async = true;
          };
        };

        completion = {
          documentation.auto_show = true;
          list.selection.preselect = false;

          menu.draw.components.kind_icon = {
            text = mkRaw ''
              function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                        icon = dev_icon
                    end
                elseif ctx.kind == "Copilot" then
                    icon = ""
                else
                    icon = require("lspkind").symbolic(ctx.kind, {
                        mode = "symbol",
                    })
                end
                return icon .. ctx.icon_gap
              end
            '';

            highlight = mkRaw ''
              function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end
            '';
          };
        };

        keymap = {
          preset = "enter";

          "<c-j>" = [
            "select_next"
            "fallback"
          ];
          "<c-k>" = [
            "select_prev"
            "fallback"
          ];

          "<up>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<down>" = [
            "scroll_documentation_down"
            "fallback"
          ];

          "c-s" = [
            "show_signature"
            "hide_signature"
            "fallback"
          ];

        };
      };
    };
  };
}

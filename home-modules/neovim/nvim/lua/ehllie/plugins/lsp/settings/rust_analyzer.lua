return {
  extended = {
    "simrat39/rust-tools.nvim",
    config = function()
      local rt = require("rust-tools")
      local handlers = require("ehllie.plugins.lsp.handlers")

      local opts = {
        on_attach = handlers.make_on_attach(function()
          return {
            ["<leader>l"] = {
              a = { rt.code_action_group.code_action_group, "Rust code actions" },
              m = { rt.expand_macro.expand_macro, "Expand macro" },
            },
            ["K"] = { rt.hover_actions.hover_actions, "Rust hover actions" },
          }
        end),
        capabilities = handlers.mk_capabilities(),
      }

      rt.setup({
        server = {
          on_attach = opts.on_attach,
          capabilities = opts.capabilities,
        },
      })
    end,
  },
}

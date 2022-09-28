local function config()
  local rt = require("rust-tools")
  local handlers = require("lsp-conf.handlers")

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
    capabilities = handlers.capabilities,
  }

  rt.setup({
    tools = {
      on_initialized = function()
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave", "BufWritePost" }, {
          callback = vim.lsp.codelens.refresh,
          pattern = "*.rs",
        })
      end,
    },
    server = {
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
          cargo = {
            extraEnv = {
              CARGO_TARGET_DIR = "/tmp/rust-analyzer",
            },
          },
        },
      },
    },
  })
end

return { extended = { "simrat39/rust-tools.nvim", config = config } }

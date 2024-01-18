return {
  extended = {

    "mrcjkb/rustaceanvim",
    version = "^3",
    ft = { "rust" },
    config = function()
      local handlers = require("ehllie.plugins.lsp.handlers")

      local on_attach = handlers.make_on_attach(function()
        return {
          ["<leader>l"] = {
            a = { "<cmd>RustLsp codeAction<CR>", "Rust code actions" },
            m = { "<cmd>RustLsp expandMacro<CR>", "Expand macro" },
          },
          ["K"] = { "<cmd>RustLsp hover actions<CR>", "Rust hover actions" },
        }
      end)

      local default_opts = {
        server = {
          on_attach = on_attach,
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
      }

      require("ehllie.utils").allow_reconfigure("rustaceanvim", function(opts)
        vim.g.rustaceanvim = opts
      end, default_opts)
    end,
  },
}

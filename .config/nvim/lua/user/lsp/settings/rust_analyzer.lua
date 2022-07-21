local function config()
  local handlers = require("user.lsp.handlers")
  local opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities,
  }
  local register = require("which-key").register

  register({
    h = { "<cmd>RustToggleInlayHints<Cr>", "Toggle inlay hints" },
    r = { "<cmd>RustRunnables<Cr>", "Rust runnables" },
  }, { prefix = "<leader>r" })

  -- keymap("n", "<leader>rh", "<cmd>RustSetInlayHints<Cr>")
  -- keymap("n", "<leader>rhd", "<cmd>RustDisableInlayHints<Cr>")
  -- keymap("n", "<leader>th", "<cmd>RustToggleInlayHints<Cr>")
  -- keymap("n", "<leader>rr", "<cmd>RustRunnables<Cr>")
  -- keymap("n", "<leader>rem", "<cmd>RustExpandMacro<Cr>")
  -- keymap("n", "<leader>roc", "<cmd>RustOpenCargo<Cr>")
  -- keymap("n", "<leader>rpm", "<cmd>RustParentModule<Cr>")
  -- keymap("n", "<leader>rjl", "<cmd>RustJoinLines<Cr>")
  -- keymap("n", "<leader>rha", "<cmd>RustHoverActions<Cr>")
  -- keymap("n", "<leader>rhr", "<cmd>RustHoverRange<Cr>")
  -- keymap("n", "<leader>rmd", "<cmd>RustMoveItemDown<Cr>")
  -- keymap("n", "<leader>rmu", "<cmd>RustMoveItemUp<Cr>")
  -- keymap("n", "<leader>rsb", "<cmd>RustStartStandaloneServerForBuffer<Cr>")
  -- keymap("n", "<leader>rd", "<cmd>RustDebuggables<Cr>")
  -- keymap("n", "<leader>rv", "<cmd>RustViewCrateGraph<Cr>")
  -- keymap("n", "<leader>rw", "<cmd>RustReloadWorkspace<Cr>")
  -- keymap("n", "<leader>rss", "<cmd>RustSSR<Cr>")
  -- keymap("n", "<leader>rxd", "<cmd>RustOpenExternalDocs<Cr>")

  require("rust-tools").setup({
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
          lens = {
            enable = true,
          },
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    },
  })
end

return { extended = { "simrat39/rust-tools.nvim", config = config, after = "nvim-lsp-installer" } }

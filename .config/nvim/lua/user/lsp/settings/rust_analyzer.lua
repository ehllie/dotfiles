return function(_, opts)
  local function setup(rust_tools, keymap)
    keymap("n", "<leader>rh", "<cmd>RustSetInlayHints<Cr>")
    keymap("n", "<leader>rhd", "<cmd>RustDisableInlayHints<Cr>")
    keymap("n", "<leader>th", "<cmd>RustToggleInlayHints<Cr>")
    keymap("n", "<leader>rr", "<cmd>RustRunnables<Cr>")
    keymap("n", "<leader>rem", "<cmd>RustExpandMacro<Cr>")
    keymap("n", "<leader>roc", "<cmd>RustOpenCargo<Cr>")
    keymap("n", "<leader>rpm", "<cmd>RustParentModule<Cr>")
    keymap("n", "<leader>rjl", "<cmd>RustJoinLines<Cr>")
    keymap("n", "<leader>rha", "<cmd>RustHoverActions<Cr>")
    keymap("n", "<leader>rhr", "<cmd>RustHoverRange<Cr>")
    keymap("n", "<leader>rmd", "<cmd>RustMoveItemDown<Cr>")
    keymap("n", "<leader>rmu", "<cmd>RustMoveItemUp<Cr>")
    keymap("n", "<leader>rsb", "<cmd>RustStartStandaloneServerForBuffer<Cr>")
    keymap("n", "<leader>rd", "<cmd>RustDebuggables<Cr>")
    keymap("n", "<leader>rv", "<cmd>RustViewCrateGraph<Cr>")
    keymap("n", "<leader>rw", "<cmd>RustReloadWorkspace<Cr>")
    keymap("n", "<leader>rss", "<cmd>RustSSR<Cr>")
    keymap("n", "<leader>rxd", "<cmd>RustOpenExternalDocs<Cr>")

    rust_tools.setup({
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

  return { deps = { "rust-tools", "user.keymaps" }, setup = setup }
end

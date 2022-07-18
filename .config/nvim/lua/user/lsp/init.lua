local function setup(lsp_installer, lspconfig, cmp_nvim_lsp, null_ls)
  local nested = {}

  local servers = {
    "bashls",
    "cssls",
    "hls",
    "html",
    "jsonls",
    "pyright",
    "rust_analyzer",
    "sumneko_lua",
    "tailwindcss",
    "volar",
    "yamlls",
  }

  lsp_installer.setup({
    automatic_installation = true,
  })

  local handlers = require("user.lsp.handlers").init(cmp_nvim_lsp)
  local opts = {}

  for _, server in pairs(servers) do
    opts = {
      on_attach = handlers.on_attach,
      capabilities = handlers.capabilities,
    }

    local opts_ok, server_opts = pcall(require, "user.lsp.settings." .. server)
    if opts_ok then
      local opt_type = type(server_opts)
      if opt_type == "table" then
        opts = vim.tbl_deep_extend("force", server_opts, opts)
        lspconfig[server].setup(opts)
      elseif opt_type == "function" then
        table.insert(nested, server_opts(lspconfig, opts))
      end
    else
      lspconfig[server].setup(opts)
    end
  end

  handlers.setup()

  local diagnostics = null_ls.builtins.diagnostics
  null_ls.setup({
    debug = false,
    sources = {
      diagnostics.flake8.with({ extra_args = { "--max-line-length", "--extend-ignore", "E203" } }),
      diagnostics.mypy,
    },
  })

  return nested
end
return { deps = { "nvim-lsp-installer", "lspconfig", "cmp_nvim_lsp", "null-ls" }, setup = setup }

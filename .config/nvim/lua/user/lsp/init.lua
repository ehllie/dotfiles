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

---@type table<table>
Basic = {}
---@type table<table>
local extended = {}

for _, server in ipairs(servers) do
  local opts_ok, server_opts = pcall(require, "user.lsp.settings." .. server)
  if opts_ok and server_opts.extended then
    table.insert(extended, server_opts.extended)
  else
    Basic[server] = opts_ok and server_opts or {}
  end
end

local function config_lspistall()
  require("nvim-lsp-installer").setup({
    automatic_installation = true,
  })

  local lspconfig = require("lspconfig")

  local handlers = require("user.lsp.handlers")
  local opts = {}

  for server, server_opts in pairs(Basic) do
    opts = {
      on_attach = handlers.on_attach,
      capabilities = handlers.capabilities,
    }

    opts = vim.tbl_deep_extend("force", opts, server_opts)
    lspconfig[server].setup(opts)
  end

  handlers.setup()
end

local function config_nls()
  local null_ls = require("null-ls")

  local diagnostics = null_ls.builtins.diagnostics
  null_ls.setup({
    debug = false,
    sources = {
      diagnostics.flake8.with({ extra_args = { "--max-line-length", "--extend-ignore", "E203" } }),
      diagnostics.mypy,
    },
  })
end

return {
  {
    "williamboman/nvim-lsp-installer",
    config = config_lspistall,
    requires = { "neovim/nvim-lspconfig", "folke/which-key.nvim" },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = config_nls,
  },
  unpack(extended),
}

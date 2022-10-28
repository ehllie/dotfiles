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
  "nil_ls",
}

---@type table<table>
Basic = {}
---@type table<table>
local extended = {}

for _, server in ipairs(servers) do
  local opts_ok, server_opts = pcall(require, "lsp-conf.settings." .. server)
  local extended_opts = opts_ok and server_opts.extended
  if extended_opts then
    extended_opts.after = vim.tbl_deep_extend("force", extended_opts.after or {}, { "nvim-lspconfig" })
    table.insert(extended, extended_opts)
  else
    Basic[server] = opts_ok and server_opts or {}
  end
end

local function config()
  local lspconfig = require("lspconfig")

  local handlers = require("lsp-conf.handlers")
  local opts = {}

  for server, server_opts in pairs(Basic) do
    opts = {
      on_attach = handlers.make_on_attach(),
      capabilities = handlers.capabilities,
    }

    opts = vim.tbl_deep_extend("force", opts, server_opts)
    lspconfig[server].setup(opts)
  end

  handlers.setup()
end

return {
  {
    "neovim/nvim-lspconfig",
    config = config,
    requires = "folke/which-key.nvim",
    after = "lsp-status.nvim",
  },
  {
    "nvim-lua/lsp-status.nvim",
    config = function()
      require("lsp-status").register_progress()
    end,
  },
  require("lsp-conf.null-ls"),
  unpack(extended),
}

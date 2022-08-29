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
  "rnix",
}

---@type table<table>
Basic = {}
---@type table<table>
local extended = {}

for _, server in ipairs(servers) do
  local opts_ok, server_opts = pcall(require, "lsp-conf.settings." .. server)
  if opts_ok and server_opts.extended then
    table.insert(extended, server_opts.extended)
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

    ---@diagnostic disable-next-line
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
  },
  require("lsp-conf.null-ls"),
  unpack(extended),
}

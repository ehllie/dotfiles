local servers = {
  "bashls",
  "cssls",
  "hls",
  "html",
  "jsonls",
  "pyright",
  "rust_analyzer",
  "lua_ls",
  "tailwindcss",
  "prismals",
  "tsserver",
  "svelte",
  "yamlls",
  "nil_ls",
  "ccls",
  "elixirls",
}

---@type table<table>
Basic = {}
---@type table<table>
local extended = {}

for _, server in ipairs(servers) do
  local opts_ok, server_opts = pcall(require, "ehllie.plugins.lsp.settings." .. server)
  local extended_opts = opts_ok and server_opts.extended
  if extended_opts then
    extended_opts.dependencies = vim.tbl_deep_extend("force", extended_opts.dependencies or {}, { "nvim-lspconfig" })
    table.insert(extended, extended_opts)
  else
    Basic[server] = opts_ok and server_opts or {}
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      local handlers = require("ehllie.plugins.lsp.handlers")
      local opts = {}

      for server, server_opts in pairs(Basic) do
        opts = {
          on_attach = handlers.make_on_attach(),
          capabilities = handlers.mk_capabilities(),
        }

        opts = vim.tbl_deep_extend("force", opts, server_opts)
        lspconfig[server].setup(opts)
      end

      handlers.setup()
    end,
    dependencies = { "lsp-status.nvim", "folke/which-key.nvim", "folke/neoconf.nvim" },
  },
  {
    "folke/neoconf.nvim",
    config = true,
  },
  {
    "nvim-lua/lsp-status.nvim",
    config = function()
      require("lsp-status").register_progress()
    end,
  },
  require("ehllie.plugins.lsp.formatter"),
  require("ehllie.plugins.lsp.linter"),
  unpack(extended),
}

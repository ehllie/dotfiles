local servers = {
  "bashls",
  "clangd",
  "cssls",
  "elixirls",
  "gleam",
  "hls",
  "html",
  "jsonls",
  "lua_ls",
  "nil_ls",
  "nushell",
  "prismals",
  "pyright",
  "rust_analyzer",
  "sourcekit",
  "sqls",
  "svelte",
  "tailwindcss",
  "ts_ls",
  "yamlls",
  "zls",
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
      local default_opts = {}

      for server, server_opts in pairs(Basic) do
        default_opts = {
          on_attach = handlers.make_on_attach(),
          capabilities = handlers.mk_capabilities(),
        }

        default_opts = vim.tbl_deep_extend("force", default_opts, server_opts)

        require("ehllie.utils").allow_reconfigure({ "lspconfig", server }, function(opts)
          lspconfig[server].setup(opts)
        end, default_opts)
      end

      handlers.setup()
    end,
    dependencies = { "lsp-status.nvim", "folke/which-key.nvim" },
  },
  {
    "nvim-lua/lsp-status.nvim",
    config = function()
      require("lsp-status").register_progress()
    end,
  },
  require("ehllie.plugins.lsp.conform"),
  require("ehllie.plugins.lsp.linter"),
  unpack(extended),
}

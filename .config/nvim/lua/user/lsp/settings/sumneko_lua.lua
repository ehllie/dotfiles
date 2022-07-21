-- return {
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { "vim" },
--       },
--       workspace = {
--         library = {
--           [vim.fn.expand("$VIMRUNTIME/lua")] = true,
--           [vim.fn.stdpath("config") .. "/lua"] = true,
--         },
--       },
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- }

local function config()
  local handlers = require("user.lsp.handlers")
  local opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities,
  }
  require("lspconfig").sumneko_lua.setup(require("lua-dev").setup({
    lspconfig = {
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
    },
  }))
end

return { extended = { "folke/lua-dev.nvim", config = config, after = "nvim-lsp-installer" } }

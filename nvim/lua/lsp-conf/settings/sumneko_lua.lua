local function config()
  local handlers = require("lsp-conf.handlers")
  local opts = {
    on_attach = handlers.make_on_attach(),
    capabilities = handlers.capabilities,
  }
  require("lspconfig").sumneko_lua.setup(require("lua-dev").setup({
    lspconfig = {
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
    },
  }))
end

return { extended = { "folke/lua-dev.nvim", config = config } }

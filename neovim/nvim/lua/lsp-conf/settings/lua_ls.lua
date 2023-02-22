local function config()
  require("neodev").setup({
    override = function(root_dir, library)
      if require("neodev.util").has_file(root_dir, "@repoDir@") then
        library.enabled = true
        library.plugins = true
      end
    end,
  })

  local handlers = require("lsp-conf.handlers")
  local on_attach = handlers.make_on_attach()
  local capabilities = handlers.mk_capabilities()

  require("lspconfig").lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = { Lua = { workspace = { checkThirdParty = false } } },
  })
end

return { extended = { "folke/neodev.nvim", config = config } }

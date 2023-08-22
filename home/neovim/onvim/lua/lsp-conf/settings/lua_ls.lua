local function config()
  require("neodev").setup({
    override = function(root_dir, library)
      if root_dir:find("@repoDir@") then
        library.enabled = true
        library.plugins = true
        library.types = true
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

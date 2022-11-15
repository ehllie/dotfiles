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
  local opts = {
    on_attach = handlers.make_on_attach(),
    capabilities = handlers.mk_capabilities(),
  }

  require("lspconfig").sumneko_lua.setup(opts)
end

return { extended = { "folke/neodev.nvim", config = config } }

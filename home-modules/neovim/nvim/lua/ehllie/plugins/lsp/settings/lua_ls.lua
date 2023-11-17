return {
  extended = {
    "folke/neodev.nvim",
    config = function()
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

      local handlers = require("ehllie.plugins.lsp.handlers")
      local on_attach = handlers.make_on_attach()
      local capabilities = handlers.mk_capabilities()

      require("lspconfig").lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = { Lua = { workspace = { checkThirdParty = false } } },
      })
    end,
  },
}

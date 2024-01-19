return {
  extended = {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup({
        override = function(root_dir, library)
          local filename = vim.fn.expand("%:t")
          if filename == ".nvim.lua" or root_dir:find("@repoDir@") then
            library.enabled = true
            library.runtime = true
            library.types = true
            library.plugins = true
          end
        end,
      })

      local handlers = require("ehllie.plugins.lsp.handlers")
      local on_attach = handlers.make_on_attach()
      local capabilities = handlers.mk_capabilities()

      local default_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = { Lua = { workspace = { checkThirdParty = false } } },
      }

      require("ehllie.utils").allow_reconfigure({ "lspconfig", "lua_ls" }, function(opts)
        require("lspconfig").lua_ls.setup(opts)
      end, default_opts)
    end,
  },
}

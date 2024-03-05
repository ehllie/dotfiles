return {
  extended = {
    "nanotee/sqls.nvim",
    config = function()
      local handlers = require("ehllie.plugins.lsp.handlers")
      local on_attach = function(client, bufnr)
        handlers.make_on_attach()(client, bufnr)
        require("sqls").on_attach(client, bufnr)
      end
      local capabilities = handlers.mk_capabilities()

      local default_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      require("ehllie.utils").allow_reconfigure({ "lspconfig", "sqls" }, function(opts)
        require("lspconfig").sqls.setup(opts)
      end, default_opts)
    end,
  },
}

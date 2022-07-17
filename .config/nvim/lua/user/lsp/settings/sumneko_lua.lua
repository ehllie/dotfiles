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

return function(lspconfig, opts)
  local status_ok, luadev = pcall(require, "lua-dev")
  if not status_ok then
    return
  end

  lspconfig.sumneko_lua.setup(luadev.setup({
    lspconfig = {
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
    },
  }))
end

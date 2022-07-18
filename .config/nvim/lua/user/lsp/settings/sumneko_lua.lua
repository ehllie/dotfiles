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
  local function setup(luadev)
    lspconfig.sumneko_lua.setup(luadev.setup({
      lspconfig = {
        on_attach = opts.on_attach,
        capabilities = opts.capabilities,
      },
    }))
  end

  return { deps = { "lua-dev" }, setup = setup }
end

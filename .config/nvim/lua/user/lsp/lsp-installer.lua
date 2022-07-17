local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local servers = {
  "sumneko_lua",
  "cssls",
  "html",
  "pyright",
  "rust_analyzer",
  "volar",
  "tailwindcss",
  "hls",
  "bashls",
  "jsonls",
  "yamlls",
}

lsp_installer.setup()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }


  local opts_ok, server_opts = pcall(require, "user.lsp.settings." .. server)
  if opts_ok then
    local opt_type = type(server_opts)
    if opt_type == "table" then
      opts = vim.tbl_deep_extend("force", server_opts, opts)
      lspconfig[server].setup(opts)
    elseif opt_type == "function" then
      server_opts(lspconfig, opts)
    end
  end

end

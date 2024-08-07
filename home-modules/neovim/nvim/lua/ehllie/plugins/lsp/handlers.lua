local M = {}

function M.mk_capabilities()
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local lsp_status = require("lsp-status")
  local capabilities = vim.tbl_deep_extend("keep", cmp_nvim_lsp.default_capabilities(), lsp_status.capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return capabilities
end

M.setup = function()
  local signs = {

    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      active = signs, -- show signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

---@param bufnr number
---@param extra? fun(): table
---@return nil
local function lsp_keymaps(bufnr, extra)
  local base = {
    { "<leader>l", group = "LSP info" },
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code actions" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP info" },
    {
      "<leader>lj",
      function()
        vim.diagnostic.goto_next({ buffer = bufnr })
      end,
      desc = "Next diagnostic",
    },
    {
      "<leader>lk",
      function()
        vim.diagnostic.goto_prev({ buffer = bufnr })
      end,
      desc = "Prev diagnostic",
    },
    { "<leader>ll", vim.lsp.codelens.run, desc = "Run codelens" },
    { "<leader>lq", vim.diagnostic.setloclist, desc = "Show all diagnostics" },
    { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
    { "<leader>ls", vim.lsp.buf.signature_help, desc = "Signature" },

    { "K", vim.lsp.buf.hover, desc = "Inspect" },

    { "g", group = "LSP info" },
    { "gD", vim.lsp.buf.declaration, desc = "Declaration" },
    { "gI", vim.lsp.buf.implementation, desc = "Implementation" },
    { "gd", vim.lsp.buf.definition, desc = "Definition" },
    { "gl", vim.diagnostic.open_float, desc = "Diagnostics" },
    { "gr", vim.lsp.buf.references, desc = "References" },
  }
  require("which-key").add({
    {
      buffer = bufnr,
      extra and extra() or {},
      base,
    },
  })
end

M.can_format = { "*.rs", "*.c", "*.h", "*.nix", "*.ex", "*.exs", "*.gleam" }

local has_codelens = { rust_analyzer = "*.rs", hls = { "*.hs", ".lhs" } }

---@param extra? fun(): table
---@return fun(client: table, bufnr: number): nil
M.make_on_attach = function(extra)
  return function(client, bufnr)
    lsp_keymaps(bufnr, extra)
    local status_ok, illuminate = pcall(require, "illuminate")
    if status_ok then
      illuminate.on_attach(client)
    end
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
    local lsp_status = require("lsp-status")
    lsp_status.on_attach(client)
    local patterns = has_codelens[client.name]
    if patterns then
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        callback = vim.lsp.codelens.refresh,
        pattern = patterns,
      })
    end
  end
end

return M

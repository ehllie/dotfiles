local M = {}

function M.mk_capabilities()
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local lsp_status = require("lsp-status")
  local capabilities = vim.tbl_deep_extend("keep", cmp_nvim_lsp.default_capabilities(), lsp_status.capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
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
  local register = require("which-key").register
  local base = {
    g = {
      name = "LSP info",
      D = { vim.lsp.buf.declaration, "Declaration" },
      d = { vim.lsp.buf.definition, "Definition" },
      I = { vim.lsp.buf.implementation, "Implementation" },
      r = { vim.lsp.buf.references, "References" },
      l = { vim.diagnostic.open_float, "Diagnostics" },
    },
    K = { vim.lsp.buf.hover, "Inspect" },
    ["<leader>l"] = {
      name = "LSP info",
      i = { "<cmd>LspInfo<cr>", "LSP info" },
      a = { vim.lsp.buf.code_action, "Code actions" },
      r = { vim.lsp.buf.rename, "Rename" },
      s = { vim.lsp.buf.signature_help, "Signature" },
      q = { vim.diagnostic.setloclist, "Show all diagnostics" },
      l = { vim.lsp.codelens.run, "Run codelens" },
      j = {
        function()
          vim.diagnostic.goto_next({ buffer = bufnr })
        end,
        "Next diagnostic",
      },
      k = {
        function()
          vim.diagnostic.goto_prev({ buffer = bufnr })
        end,
        "Prev diagnostic",
      },
    },
  }
  register(vim.tbl_deep_extend("force", base, extra and extra() or {}), { buffer = bufnr })
end

M.can_format = { "rust_analyzer", "ccls" }

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

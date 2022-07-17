local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local diagnostics = null_ls.builtins.diagnostics
null_ls.setup({
  debug = false,
  sources = {
    diagnostics.flake8.with({ extra_args = { "--max-line-length", "--extend-ignore", "E203" } }),
    diagnostics.mypy,
  },
})

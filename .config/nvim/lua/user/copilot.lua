local status_ok, copilot = pcall(require, "copilot")
if not status_ok then
  return
end

vim.defer_fn(function()
  copilot.setup({
    cmp = {
      enabled = true,
      method = "getPanelCompletions",
    },
    panel = {
      enabled = true,
    },
  })
end, 100)

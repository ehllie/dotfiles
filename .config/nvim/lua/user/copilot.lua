local status_ok, copilot = pcall(require, "copilot")
if not status_ok then
  return
end

copilot.setup({
  cmp = {
    enabled = true,
    method = "getPanelCompletions",
  },
  panel = {
    enabled = true,
  },
})

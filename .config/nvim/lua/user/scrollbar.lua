local status_ok, scrollbar = pcall(require, "scrollbar")
if not status_ok then
  return
end

-- augroup ScrollbarInit
--   autocmd!
--   autocmd WinScrolled,VimResized,QuitPre * silent! lua require('scrollbar').show()
--   autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
--   autocmd WinLeave,BufLeave,BufWinLeave,FocusLost            * silent! lua require('scrollbar').clear()
-- augroup end

vim.api.nvim_create_autocmd({ "WinScrolled", "VimResized", "QuitPre" }, {
  callback = function()
    scrollbar.show()
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  callback = function()
    scrollbar.show()
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "BufWinLeave", "FocusLost" }, {
  callback = function()
    scrollbar.clear()
  end,
})

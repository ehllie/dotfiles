local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install your plugins here
require("lazy").setup({
  -- require("lsp-conf"),
  -- require("plug-conf.alpha"),
  -- require("plug-conf.bufferline"),
  -- require("plug-conf.cmp"),
  -- require("plug-conf.comment"),
  -- require("plug-conf.dap"),
  -- require("plug-conf.hop"),
  -- require("plug-conf.lualine"),
  -- require("plug-conf.misc"),
  -- require("plug-conf.nvim-tree"),
  -- require("plug-conf.presence"),
  -- require("plug-conf.symbols-outline"),
  -- require("plug-conf.telescope"),
  -- require("plug-conf.theme"),
  -- require("plug-conf.toggleterm"),
  -- require("plug-conf.treesitter"),
  -- require("plug-conf.which-key"),
  -- require("plug-conf.gitsigns"),
  -- require("plug-conf.neorg"),
}, {
  lockfile = "@repoDir@/lazy-lock.json",
})

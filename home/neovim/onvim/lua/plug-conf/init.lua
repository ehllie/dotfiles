local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup({
  function(use)
    use({ "wbthomason/packer.nvim" }) -- Have packer manage itself

    -- Depencancy and config setup for plugins in separate files
    use(require("lsp-conf"))
    use(require("plug-conf.alpha"))
    use(require("plug-conf.bufferline"))
    use(require("plug-conf.cmp"))
    use(require("plug-conf.comment"))
    use(require("plug-conf.dap"))
    use(require("plug-conf.hop"))
    use(require("plug-conf.lualine"))
    use(require("plug-conf.misc"))
    use(require("plug-conf.nvim-tree"))
    use(require("plug-conf.presence"))
    use(require("plug-conf.symbols-outline"))
    use(require("plug-conf.telescope"))
    use(require("plug-conf.theme"))
    use(require("plug-conf.toggleterm"))
    use(require("plug-conf.treesitter"))
    use(require("plug-conf.which-key"))
    use(require("plug-conf.gitsigns"))
    -- use(require("plug-conf.session-manager"))
    use(require("plug-conf.neorg"))

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
      require("packer").sync()
    end
  end,
  config = {
    profile = { enable = true },
    git = { clone_timeout = 10 },
  },
})

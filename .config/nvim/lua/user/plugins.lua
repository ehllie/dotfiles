local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
---@diagnostic disable-next-line: missing-parameter
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

    use({
      "kyazdani42/nvim-web-devicons",
      {
        "lambdalisue/suda.vim",
        config = function()
          require("which-key").register({ ["w!!"] = { "SudaWrite", "Write as superuser" } }, { mode = "c" })
        end,
        requires = "folke/which-key.nvim",
      },
      "michaeljsmith/vim-indent-object",
      "moll/vim-bbye",
      "nvim-lua/plenary.nvim", -- Useful lua functions used by lots of plugins
      "tpope/vim-surround",
    })

    -- TODO: Configure symbols-outline
    use({ "simrat39/symbols-outline.nvim" })

    -- Depencancy and config setup for plugins in separate files
    use(require("user.alpha"))
    use(require("user.bufferline"))
    use(require("user.cmp"))
    use(require("user.comment"))
    use(require("user.dap"))
    use(require("user.formatter"))
    use(require("user.hop"))
    use(require("user.lsp"))
    use(require("user.lualine"))
    use(require("user.misc"))
    use(require("user.nvim-tree"))
    use(require("user.presence"))
    use(require("user.telescope"))
    use(require("user.toggleterm"))
    use(require("user.treesitter"))
    -- TODO: Load keybinds declared in a global table at the end of init
    -- That way each plugin that sets up keybibds won't depend on which-key
    use(require("user.which-key"))

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
      require("packer").sync()
    end
  end,
  config = { profile = { enable = true } },
})

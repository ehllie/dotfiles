local function config()
  local session_manager = require("session_manager")
  local sm_config = require("session_manager.config")
  local is_in = require("utils").is_in

  session_manager.setup({
    autoload_mode = sm_config.AutoloadMode.Disabled,
  })

  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      if not is_in(vim.bo.filetype, { "git", "gitcommit" }) then
        -- session_manager.autosave_session()
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "DirChanged" }, {
    callback = function()
      -- session_manager.load_current_dir_session()
    end,
  })
end
return {
  "Shatur/neovim-session-manager",
  config = config,
  requires = "nvim-lua/plenary.nvim",
}

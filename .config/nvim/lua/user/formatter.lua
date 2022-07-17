local formatter_status_ok, formatter = pcall(require, "formatter")
if not formatter_status_ok then
  return
end

local util_status_ok, util = pcall(require, "formatter.util")
if not util_status_ok then
  return
end

local function path()
  return util.escape_path(util.get_current_buffer_file_path())
end

local function black()
  return {
    exe = "black",
    args = { "--fast", "-q", "-" },
    stdin = true,
  }
end

local function isort()
  return {
    exe = "isort",
    args = {
      "--profile",
      "black",
      "-q",
      "-",
    },
    stdin = true,
  }
end

local function stylua()
  return {
    exe = "stylua",
    args = {
      "--indent-type",
      "spaces",
      "--indent-width",
      "2",
      "--stdin-filepath",
      path(),
      "--",
      "-",
    },
    stdin = true,
  }
end

local function prettier()
  return function()
    return {
      exe = "prettier",
      args = {
        "--single-quote",
        "--stdin-filepath",
        path(),
      },
      stdin = true,
    }
  end
end

local function rustfmt()
  return {
    exe = "rustfmt",
    stdin = true,
  }
end

formatter.setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    python = {
      isort,
      black,
    },
    lua = { stylua },
    typescript = { prettier },
    javascript = { prettier },
    json = { prettier },
    html = { prettier },
    css = { prettier },
    vue = { prettier },
    yaml = { prettier },
    rust = { rustfmt },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    vim.cmd("FormatWrite")
  end,
})

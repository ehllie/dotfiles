local function config()
  local util = require("formatter.util")
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
        "--search-parent-directories",
        "--stdin-filepath",
        path(),
        "--",
        "-",
      },
      stdin = true,
    }
  end

  local function prettier()
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

  local function rustfmt()
    return {
      exe = "rustfmt",
      stdin = true,
    }
  end

  local function nixfmt()
    return {
      exe = "nixpkgs-fmt",
      stdin = true,
    }
  end

  require("formatter").setup({
    logging = true,
    log_level = vim.log.levels.ERROR,
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
      nix = { nixfmt },
      ["*"] = {
        require("formatter.filetypes.any").remove_trailing_whitespace,
      },
    },
  })
end

return { "mhartington/formatter.nvim", config = config }

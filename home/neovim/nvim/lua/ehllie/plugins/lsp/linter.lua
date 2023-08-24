return {
  "mfussenegger/nvim-lint",
  config = function()
    local utils = require("ehllie.utils")
    local lint = require("lint")

    lint.linters.flake8.args =
      utils.concat({ { "--max-line-length", "88", "--extend-ignore", "E203" } }, lint.linters.flake8.args)

    lint.linters_by_ft = vim.tbl_deep_extend(
      "force",
      {
        python = { "flake8" },
      },
      utils.transform_table(function(_, filetype)
        return filetype, { "eslint" }
      end, {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
      })
    )

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}

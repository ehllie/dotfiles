return {
  {
    "github/copilot.vim",
    lazy = true,
  },
  {
    "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function(_, opts)
      vim.defer_fn(function()
        require("copilot").setup(opts)
        require("which-key").add({
          { "<leader>p", "<cmd>Copilot panel<CR>", desc = "Open copilot panel" },
        })
      end, 100)
    end,
    opts = {
      suggestion = { enabled = false },
      filetypes = {
        help = false,
        dashboard = false,
        ["dap-repl"] = false,
      },
      copilot_node_command = store.node .. "/bin/node",
    },
    dependencies = { "zbirenbaum/copilot-cmp" },
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = true,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = true,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local tw_colorizer = require("tailwindcss-colorizer-cmp")
      require("luasnip.loaders.from_vscode").lazy_load()

      local kind_icons = {
        Class = symbols.Class,
        Color = symbols.Color,
        Constant = symbols.Constant,
        Constructor = symbols.Constructor,
        Enum = symbols.Enum,
        EnumMember = symbols.EnumMember,
        Event = symbols.Event,
        Field = symbols.Field,
        File = symbols.File,
        Folder = symbols.Folder,
        Function = symbols.Function,
        Interface = symbols.Interface,
        Keyword = symbols.Keyword,
        Method = symbols.Method,
        Module = symbols.Module,
        Operator = symbols.Operator,
        Property = symbols.Property,
        Reference = symbols.Reference,
        Snippet = symbols.Snippet,
        Struct = symbols.Struct,
        Text = symbols.Text,
        TypeParameter = symbols.TypeParameter,
        Unit = symbols.Unit,
        Value = symbols.Value,
        Variable = symbols.Variable,
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          -- Accept currently selected item. If none selected, `select` first item.
          -- Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            vim_item.kind = kind_icons[vim_item.kind]
            vim_item.menu = ({
              nvim_lsp = "",
              nvim_lua = "",
              luasnip = "",
              buffer = "",
              path = "",
              emoji = "",
            })[entry.source.name]

            if entry.source.name == "copilot" then
              vim_item.kind = symbols.Copilot
              vim_item.kind_hl_group = "CmpItemKindCopilot"
            end

            return tw_colorizer.formatter(entry, vim_item)
          end,
        },
        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "nvim_lsp_signature_help" },
          { name = "buffer" },
          { name = "path" },
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = false,
        },
      })
    end,
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp",
      "roobert/tailwindcss-colorizer-cmp.nvim",
    },
  },
}

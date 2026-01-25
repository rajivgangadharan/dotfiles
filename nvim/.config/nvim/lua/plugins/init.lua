return {
  -- Formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Mason - LSP/formatter installer
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "lua-language-server",
        "pyright",
        "typescript-language-server",
        "rust-analyzer",
        "html-lsp",
        "css-lsp",
        "marksman",
        "json-lsp",
        -- Formatters
        "stylua",
        "black",
        "prettier",
      },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "python",
        "javascript",
        "typescript",
        "rust",
        "markdown",
        "markdown_inline",
        "json",
        "org",
      },
    },
  },

  -- Orgmode
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      require("orgmode").setup {
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
      }
    end,
  },

  -- Flutter tools
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },

  -- OpenCode AI assistant
  {
    "sudo-tee/opencode.nvim",
    config = function()
      require("opencode").setup {}
    end,
    dependencies = {
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { "markdown", "opencode_output" },
        },
        ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
      },
    },
  },

  -- Claude Code
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("claude-code").setup()
    end,
  },

  -- OFFICE: Uncomment to use GitHub Copilot instead of OpenCode
  -- {
  --   "github/copilot.vim",
  --   event = "InsertEnter",
  --   config = function()
  --     vim.g.copilot_no_tab_map = true
  --     vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
  --       expr = true,
  --       replace_keycodes = false,
  --       silent = true,
  --     })
  --     vim.keymap.set("i", "<C-K>", "<Plug>(copilot-dismiss)", { silent = true })
  --     vim.keymap.set("i", "<C-L>", "<Plug>(copilot-next)", { silent = true })
  --     vim.keymap.set("i", "<C-H>", "<Plug>(copilot-previous)", { silent = true })
  --   end,
  -- },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Auto tags for HTML/JSX
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = true,
  },
}

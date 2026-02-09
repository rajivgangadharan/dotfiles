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
    cmd = "Opencode",
    config = function()
      require("opencode").setup {
        -- Core settings
        default_mode = "build",
        keymap_prefix = "<leader>O",

        -- UI configuration
        ui = {
          position = "right",
          input_position = "bottom",
          window_width = 0.40,
          zoom_width = 0.8,
          input_height = 0.15,
          display_model = true,
          display_context_size = true,
          display_cost = true,
          output = {
            tools = {
              show_output = true,
              show_reasoning_output = true,
            },
            always_scroll_to_bottom = false,
          },
          input = {
            text = { wrap = true },
            auto_hide = false,
          },
        },

        -- Context settings
        context = {
          enabled = true,
          diagnostics = {
            enabled = true,
            info = false,
            warning = true,
            error = true,
          },
          current_file = {
            enabled = true,
            show_full_path = true,
          },
          selection = {
            enabled = true,
          },
          git_diff = {
            enabled = false,
          },
        },

        -- Quick chat settings
        quick_chat = {
          default_agent = "plan",
        },
      }
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

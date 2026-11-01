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
        "nixd",
        "bash-language-server",
        "yaml-language-server",
        "taplo",
        "vscode-eslint-language-server",
        -- Formatters
        "stylua",
        "prettier",
        "shfmt",
        -- Linters
        "ruff",
        "shellcheck",
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
        "ocaml",
        "ocaml_interface",
        "markdown",
        "markdown_inline",
        "json",
        "org",
        "bash",
        "nix",
        "toml",
        "yaml",
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

  -- Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              check = { command = "clippy" },
              procMacro = { enable = true },
              imports = { granularity = { group = "module" } },
              inlayHints = {
                chainingHints = { enable = true },
                lifetimeElisionHints = { enable = "skip_trivial" },
                parameterHints = { enable = true },
                typeHints = { enable = true },
              },
            },
          },
        },
      }
    end,
  },

  -- Cargo.toml dependency management
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup()
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      require "configs.lint"
    end,
  },

  -- Command line / notification / message UI overhaul
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          timeout = 3000,
          render = "compact",
          stages = "fade",
          max_width = 50,
        },
      },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        -- hover and signature_help borders handled via vim.lsp.handlers
        hover = { enabled = false },
        signature = { enabled = false },
      },
      presets = {
        bottom_search = true,        -- keep / and ? at the bottom
        command_palette = true,      -- float the : command line
        long_message_to_split = true, -- long messages go to a split
      },
    },
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup {
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        duration_multiplier = 1.0,
        easing = "linear",
      }
    end,
  },

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

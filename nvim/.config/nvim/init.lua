-- Basic settings
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Incremental search
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.smartcase = true -- Override ignorecase if search contains capitals
vim.opt.tabstop = 4 -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for autoindent
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.cursorline = true -- Highlight the current line
vim.opt.wrap = false -- Disable line wrapping
vim.opt.scrolloff = 8 -- Minimum lines to keep above and below the cursor
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.clipboard = "unnamedplus" -- Use the system clipboard
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.splitright = true -- Vertical splits open to the right
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- Prevent Treesitter & LSP from running on large files
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  callback = function(args) -- Pass args to the callback
    local max_filesize = 100 * 1024 -- 100 KB
    local filepath = args.file -- Use args.file for the filepath
    local ok, stats = pcall(vim.uv.fs_stat, filepath)
    if ok and stats and stats.size > max_filesize then
      vim.cmd "TSDisable"
      local clients = vim.lsp.get_active_clients { bufnr = args.buf } -- Get clients associated with the buffer
      for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
      end
    end
  end,
})

-- Set leader key to space
vim.g.mapleader = " "

-- File explorer
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true, desc = "Toggle file explorer" })

-- Key mappings for LSP actions
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })

-- Set up Lazy.nvim as plugin manager
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configuration
require("lazy").setup {
  require("plugins.sessions"),
  "psf/black",
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require "null-ls"
      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylua,
        },
      }
    end,
  },
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  "nvim-telescope/telescope.nvim",
  { "nvim-treesitter/nvim-treesitter", branch = "master", run = ":TSUpdate" },
  "neovim/nvim-lspconfig",
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "marksman", "jsonls", "pyright", "ts_ls", "rust_analyzer", "html", "cssls" },
        automatic_installation = true,
      }
    end,
  },
  { "hrsh7th/nvim-cmp" },
  "hrsh7th/cmp-nvim-lsp",
  { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
  "nvim-tree/nvim-web-devicons",
  "nvim-neo-tree/neo-tree.nvim",
  "nvim-orgmode/orgmode",
  "windwp/nvim-ts-autotag",
  "windwp/nvim-autopairs",
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup()
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim", -- optional for vim.ui.select
    },
    config = true,
  },
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
  -- OFFICE: Uncomment the following section to use GitHub Copilot instead of OpenCode
  -- Make sure to comment out or remove the opencode.nvim plugin above when enabling Copilot
  -- {
  --   "github/copilot.vim",
  --   event = "InsertEnter",
  --   config = function()
  --     -- Copilot keybindings
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
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup()
    end,
  },
}

require("catppuccin").setup {
  flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
  integrations = {
    treesitter = true,
    telescope = true,
    cmp = true,
    gitsigns = true,
    nvimtree = true,
  },
}
vim.cmd.colorscheme "catppuccin"

-- Treesitter settings
require("nvim-treesitter.configs").setup {
  ensure_installed = { "lua", "python", "javascript", "rust", "markdown", "markdown_inline", "json" },
  highlight = { enable = true },
}

-- Telescope settings
require("telescope").setup {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    path_display = { "smart" },
  },
}

-- Autoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.py", "*.js", "*.ts", "*.html", "*.css", "*.json", "*.md" },
  callback = function()
    vim.lsp.buf.format { async = false }
  end,
})

-- Configuring LSP
local lspconfig = require "lspconfig"
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Auto-setup all LSP servers installed by Mason
require("mason-lspconfig").setup_handlers {
  -- Default handler for all servers
  function(server_name)
    lspconfig[server_name].setup {
      capabilities = capabilities,
    }
  end,
  -- Custom handler for ts_ls (disable formatting, use prettier instead)
  ["ts_ls"] = function()
    lspconfig.ts_ls.setup {
      capabilities = capabilities,
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
      end,
    }
  end,
  -- Custom handler for rust_analyzer
  ["rust_analyzer"] = function()
    lspconfig.rust_analyzer.setup {
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = { command = "clippy" },
        },
      },
    }
  end,
}

local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
}

-- luasnip setup
require("luasnip.loaders.from_vscode").lazy_load()

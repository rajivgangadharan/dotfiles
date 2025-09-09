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
  callback = function()
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.fn.expand "%:p")
    if ok and stats and stats.size > max_filesize then
      vim.cmd "TSDisable"
      vim.lsp.stop_client(vim.lsp.get_active_clients())
    end
  end,
})

-- Key mappings for LSP actions
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })

-- Set up Lazy.nvim as plugin manager
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
  "psf/black",
  "jose-elias-alvarez/null-ls.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "nvim-tree/nvim-web-devicons",
  "nvim-neo-tree/neo-tree.nvim",
  "nvim-orgmode/orgmode",
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup()
      vim.cmd.colorscheme "catppuccin"
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
  ensure_installed = { "lua", "python", "javascript", "rust" },
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

-- Autoformat with null-ls.nvim
local null_ls = require "null-ls"
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua,
  },
}
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.py", "*.js", "*.ts", "*.html", "*.css" },
  callback = function()
    vim.lsp.buf.format { async = false }
  end,
})

-- Configuring LSP
local lspconfig = require "lspconfig"
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.pyright.setup { capabilities = capabilities }
lspconfig.ts_ls.setup {
  capabilities = capabilities,
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
  end,
}
lspconfig.rust_analyzer.setup {
  settings = { ["rust-analyzer"] = { cargo = { allFeatures = true }, checkOnSave = { command = "clippy" } } },
}

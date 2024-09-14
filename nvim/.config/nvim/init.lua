-- Basic settings
vim.opt.number = true            -- Show line numbers
vim.opt.relativenumber = true    -- Relative line numbers
vim.opt.hlsearch = true          -- Highlight search results
vim.opt.incsearch = true         -- Incremental search
vim.opt.ignorecase = true        -- Case insensitive searching
vim.opt.smartcase = true         -- Override ignorecase if search contains capitals
vim.opt.tabstop = 4              -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 4           -- Number of spaces to use for autoindent
vim.opt.expandtab = true         -- Convert tabs to spaces
vim.opt.cursorline = true        -- Highlight the current line
vim.opt.wrap = false             -- Disable line wrapping
vim.opt.scrolloff = 8            -- Minimum lines to keep above and below the cursor
vim.opt.signcolumn = "yes"       -- Always show the sign column
vim.opt.clipboard = "unnamedplus"-- Use the system clipboard
vim.opt.mouse = "a"              -- Enable mouse support
vim.opt.splitright = true        -- Vertical splits open to the right
vim.opt.splitbelow = true        -- Horizontal splits open below

-- Tag settings
vim.opt.tags = {"./tags","tags;/"}
vim.opt.tagstack = true          -- Enable tag stack navigation

-- Key mappings for tag navigation
vim.api.nvim_set_keymap('n', '<C-]>', '<C-]>', { noremap = true, silent = true }) -- Jump to the tag under the cursor
vim.api.nvim_set_keymap('n', '<C-t>', '<C-t>', { noremap = true, silent = true }) -- Jump back in the tag stack

-- Set up Lazy.nvim as plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configuration
require("lazy").setup({
  -- Plugin list
  "nvim-lua/plenary.nvim",  -- Useful lua functions used by lots of plugins
  "nvim-telescope/telescope.nvim",  -- Fuzzy finder
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },  -- Treesitter configurations and abstraction layer
  "neovim/nvim-lspconfig",  -- Quickstart configurations for the Nvim LSP client
  "hrsh7th/nvim-cmp",  -- Autocompletion plugin
  "hrsh7th/cmp-nvim-lsp",  -- LSP source for nvim-cmp
  "L3MON4D3/LuaSnip",  -- Snippet engine
})


-- Treesitter settings
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "python", "javascript", "rust" }, -- Add other languages here
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}

-- Telescope settings
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    path_display = { "smart" },
  }
}


-- Configuring lsp
lspconfig = require('lspconfig')

-- Enable language servers here
lspconfig.pyright.setup{}
lspconfig.ts_ls.setup{}
lspconfig.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = "clippy", -- or `cargo check`
      },
    },
  },
})


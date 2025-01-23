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
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

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
  "psf/black",
  "jose-elias-alvarez/null-ls.nvim",
  "nvim-lua/plenary.nvim",  -- Useful lua functions used by lots of plugins
  "nvim-telescope/telescope.nvim",  -- Fuzzy finder
  { 
      "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" 
  },  -- Treesitter configurations and abstraction layer
  "neovim/nvim-lspconfig",  -- Quickstart configurations for the Nvim LSP client
  "hrsh7th/nvim-cmp",  -- Autocompletion plugin
  "hrsh7th/cmp-nvim-lsp",  -- LSP source for nvim-cmp
  "L3MON4D3/LuaSnip",  -- Snippet engine
  {
      'folke/which-key.nvim',
      event = 'BufWinEnter',
      config = function()
          require('which-key').setup {}
      end,
  },
  {
      'nvim-orgmode/orgmode',
      event='VeryLazy',
      ft = {'org'},
      config = function()
          require('orgmode').setup({
              org_agenda_files = '~/orgfiles/**/*',
              org_default_notes_file = '~/orgfiles/refile.org',
          })
      end,
  },
  {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
      require("catppuccin").setup()
      -- setup must be called before loading
      vim.cmd.colorscheme "catppuccin"
      end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  }
})

-- nvim-cmp setup
local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body) -- For `LuaSnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})


-- Treesitter settings
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "python", "javascript", "rust"}, -- Add other languages here
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = {'org'},
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
--

-- Add capabilities from nvim-cmp to the LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Pyright setup for Python LSP with autocompletion
lspconfig.pyright.setup{
  on_attach = function(client, bufnr)
    -- Custom keybindings for LSP
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  end,
  capabilities = capabilities,  -- Add this line to integrate cmp capabilities
  flags = {
    debounce_text_changes = 150,
  },
}


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

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.cmd("Black")
    end,
})


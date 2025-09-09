return require('lazy').setup({
  -- LSP Config for Rust
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')
      lspconfig.rust_analyzer.setup({
        on_attach = function(_, bufnr)
          -- LSP keybindings
          local opts = { noremap = true, silent = true }
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        end,
      })
    end,
  },

  -- Rust Tools
  {
    'simrat39/rust-tools.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('rust-tools').setup({})
    end,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path' },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        mapping = {
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        },
      })
    end,
  },

  -- Treesitter for Rust syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'rust', 'lua' }, -- Add other languages as needed
        highlight = { enable = true },
      })
    end,
  },

  -- Fuzzy Finder (Telescope)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({})
    end,
  },
  { 'rust-lang/rust.vim' },
  {
      'mrcjkb/rustaceanvim',
      version = '^3',
      ft = { 'rust' },
  }
  -- Other useful plugins...
})


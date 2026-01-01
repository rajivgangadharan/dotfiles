-- Bootstrap lazy.nvim (omitted for brevity)
-- ...

-- Set global options
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup {
  spec = {
    -- Automatically imports all files in the lua/plugins directory
    { import = "plugins" },
  },
  -- Configure lazy.nvim itself (optional)
  install = {
    colorscheme = { "habamax" },
  },
  checker = {
    enabled = true,
  },
}

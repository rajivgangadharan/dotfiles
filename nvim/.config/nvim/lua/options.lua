require "nvchad.options"

local o = vim.o

-- Your custom options from previous config
o.number = true
o.relativenumber = true
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.cursorline = true
o.wrap = false
o.scrolloff = 8
o.signcolumn = "yes"
o.clipboard = "unnamedplus"
o.mouse = "a"
o.splitright = true
o.splitbelow = true
o.spelllang = "en_us"
-- spell off by default; enabled per-filetype below for prose
o.colorcolumn = "100"
o.undofile = true

-- Enable spell checking only for prose filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "org" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Show trailing whitespace and non-breaking spaces
vim.opt.list = true
vim.opt.listchars = { trail = "·", nbsp = "␣" }

-- Diagnostic display: nerd font icons, rounded floats, sorted by severity
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.INFO]  = "",
      [vim.diagnostic.severity.HINT]  = "󰌵",
    },
  },
  virtual_text = { prefix = "●" },
  float = { border = "rounded" },
  severity_sort = true,
  update_in_insert = false,
}

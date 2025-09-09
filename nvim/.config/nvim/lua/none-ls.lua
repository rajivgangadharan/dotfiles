return {
  "nvimtools/none-ls.nvim", -- calls none-ls through short github url
  config = function()
    local null_ls = require "null-ls"
    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.stylua, -- formatter for lua installed with Mason
        null_ls.builtins.formatting.black, -- formatter for python installed with Mason
        null_ls.builtins.formatting.isort, -- formatter for python installed with Mason
      },
    }
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {}) -- for instance, adds double quotes instead of single quotes when the relevant language server advices it
  end,
}

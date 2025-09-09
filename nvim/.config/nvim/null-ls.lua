local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    require("null-ls").builtins.formatting.shfmt,
    require("null-ls").builtins.formatting.prettier, -- markdown formatting
    -- Example: Configure a formatter like black
    null_ls.builtins.black.init({
      -- Optional: Add a command alias for black
      command = { "black", "--line-length", "100" },
      -- Optional: Specify file types to apply to
      filetypes = { "python" },
    }),
  },
})

local configs = require "nvchad.configs.lspconfig"

-- Sets up base config (capabilities, on_init, on_attach autocmd) and lua_ls
configs.defaults()

-- Custom config for rust_analyzer
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    },
  },
})

-- Disable formatting for ts_ls (use prettier instead)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "ts_ls" then
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
})

-- Enable all servers
vim.lsp.enable {
  "pyright",
  "ts_ls",
  "rust_analyzer",
  "html",
  "cssls",
  "marksman",
  "jsonls",
}

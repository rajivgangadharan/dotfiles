local configs = require "nvchad.configs.lspconfig"

-- Sets up base config (capabilities, on_init, on_attach autocmd) and lua_ls
configs.defaults()

-- Disable formatting for servers where an external tool owns it
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and (client.name == "ts_ls" or client.name == "eslint") then
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
})

-- Rounded borders on LSP hover and signature help floats
vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Enable all servers (rust_analyzer managed by rustaceanvim)
vim.lsp.enable {
  "pyright",
  "ts_ls",
  "html",
  "cssls",
  "marksman",
  "jsonls",
  "ocamllsp",   -- provided by nix-ocaml environment
  "nixd",
  "bashls",
  "yamlls",
  "taplo",
  "eslint",
  "gopls",
}

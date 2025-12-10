-- Additional LSP configurations
-- Note: Main LSP setup is in init.lua
-- This file can be used for additional LSP servers

local lspconfig = require "lspconfig"
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = { "html", "cssls", "marksman", "jsonls" }

-- Setup additional LSP servers with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

-- Lua LSP with specific settings for Neovim development
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

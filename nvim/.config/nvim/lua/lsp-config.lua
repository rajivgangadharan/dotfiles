return {
    {
        "williamboman/mason.nvim", -- installation
        lazy = false,
        config = function()
            require("mason").setup() -- setup
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim", -- installation
        lazy = false,
        opts = {
            auto_install = true, -- instead of something like ensure_installed = { "lua_ls", "pyright" },
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            lspconfig.html.setup({
                capabilities = capabilities,
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}
none-ls.lua:

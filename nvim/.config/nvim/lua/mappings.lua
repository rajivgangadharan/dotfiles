require "nvchad.mappings"

local map = vim.keymap.set

-- General mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- File explorer (NvChad uses nvim-tree by default with <C-n>)
-- If you prefer <leader>e:
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- LSP mappings
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Uncomment to enable Ctrl+s to save
-- map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Rust-specific mappings (buffer-local, only active in .rs files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    local buf = { buffer = true }
    map("n", "<leader>rr", function() vim.cmd.RustLsp "runnables" end,   vim.tbl_extend("force", buf, { desc = "Rust runnables" }))
    map("n", "<leader>rt", function() vim.cmd.RustLsp "testables" end,   vim.tbl_extend("force", buf, { desc = "Rust testables" }))
    map("n", "<leader>rx", function() vim.cmd.RustLsp "expandMacro" end, vim.tbl_extend("force", buf, { desc = "Rust expand macro" }))
    map("n", "<leader>rc", function() vim.cmd.RustLsp "openCargo" end,   vim.tbl_extend("force", buf, { desc = "Rust open Cargo.toml" }))
    map("n", "<leader>rp", function() vim.cmd.RustLsp "parentModule" end, vim.tbl_extend("force", buf, { desc = "Rust parent module" }))
    map("n", "J",          function() vim.cmd.RustLsp "joinLines" end,   vim.tbl_extend("force", buf, { desc = "Rust join lines" }))
  end,
})

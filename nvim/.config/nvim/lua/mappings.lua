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

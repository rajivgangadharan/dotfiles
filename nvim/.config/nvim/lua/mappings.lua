-- Custom key mappings
-- Note: Main LSP mappings are set in init.lua

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Uncomment to enable Ctrl+s to save
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

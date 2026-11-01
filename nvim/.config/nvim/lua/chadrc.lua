---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",

  hl_override = {
    Comment               = { italic = true },
    ["@comment"]          = { italic = true },
    LspInlayHint          = { fg = "#6c7086", italic = true },
    ["@keyword"]          = { bold = true },
    ["@keyword.function"] = { bold = true },
    ["@keyword.return"]   = { bold = true },
    ["@string"]           = { italic = true },
    ["@string.escape"]    = { italic = true },
    ["@type.builtin"]     = { italic = true },
    ["@variable.builtin"] = { italic = true, bold = true },
  },
}

M.ui = {
  statusline = {
    theme = "vscode_colored",
  },
}

return M

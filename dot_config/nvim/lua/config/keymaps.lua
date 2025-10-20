-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local ks = vim.keymap.set
local wk = require("which-key")

wk.add({
  { "<leader>a", group = "custom" },
  { "<leader>m", group = "quickfix" },
  { "<leader>q", group = "Buffer close" },
})

ks("n", "<leader>au", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle LSP inlay hints" })

ks("n", "<leader>as", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Substitute word under cursor (global, case-insensitive)"
})

ks("n", "<leader>df", vim.diagnostic.open_float, {
  desc = "Show diagnostic message in float"
})

-- Buffer navigation
ks("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next buffer" })
ks("n", "<leader>bN", "<cmd>bp<cr>", { desc = "Previous buffer" })

-- Buffer close
ks("n", "<leader>qq", "<cmd>w | bd<cr>", { desc = "Write and close buffer" })
ks("n", "<leader>qz", "<cmd>bd<cr>", { desc = "Close buffer without saving" })

-- Indent in visual mode and stay in selection
ks("v", "<", "<gv", { desc = "Indent left and reselect" })
ks("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Indent in normal mode
ks("n", "<", "<<", { desc = "Indent line left" })
ks("n", ">", ">>", { desc = "Indent line right" })

ks("t", "<C-ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
ks("t", "<C-\\>n", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Quickfix list navigation
ks("n", "<leader>mk", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
ks("n", "<leader>mj", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

ks({ "n", "v" }, "<M-d>d", [["_d]], { desc = "without yanking" })
ks("n", "<M-D>d", [["_dd]], { desc = "delete line without yanking" })

ks({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
ks({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
ks("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- vim.keymap.set({'n', 'v'}, 'j', "v:count == 0 ? 'gj' : 'j'", {expr = true,})
-- vim.keymap.set({'n', 'v'}, 'k', "v:count == 0 ? 'gk' : 'k'", {expr = true,})

-- vim.keymap.set("n", "<leader>[", vim.diagnostic.goto_next) -- ]d
-- vim.keymap.set("n", "<leader>]", vim.diagnostic.goto_prev) -- [d

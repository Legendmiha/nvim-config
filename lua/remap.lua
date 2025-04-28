vim.g.mapleader = " "
-- open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move selected lines 1 line down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- move selected lines 1 line up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- select whole file
vim.keymap.set("n", "<leader>V", "<esc>gg0VG<cr>")
-- move line below at the end of the current line
vim.keymap.set("n", "J", "mzJ`z")
-- scroll down half a page and center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- scroll up half a page and center
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- search next, center and enter visual mode
vim.keymap.set("n", "n", "nzzzv")
-- search previous, center and enter visual mode
vim.keymap.set("n", "N", "Nzzzv")
-- auto-indent around paragraph without moving the cursor
vim.keymap.set("n", "=ap", "ma=ap'a")

-- paste by replacing selected lines without copying removed lines
vim.keymap.set("x", "<leader>p", [["_dP]])

-- copy to system clipboard current selection
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- copy to system clipboard whole line
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete without saving to the register (copying)
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- use the LSP server to auto-format the current buffer
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Jump to the next quickfix item (errors, search matches, etc.)
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- Jump to the previous quickfix item (errors, search matches, etc.)
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- Jump to the next location list item
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- Jump to the previous location list item
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Start a find and replace across the whole file for the exact word under your cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end)

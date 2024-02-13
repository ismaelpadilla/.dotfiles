vim.keymap.set("n", "<leader><leader>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

--vim.keymap.set("n", "<expr> k", "(v:count > 5 ? \"m'\" . v:count : \"\") . 'k'")
--vim.keymap.set("n", "<expr> j", "(v:count > 5 ? "m'" . v:count : "") . 'j'")

vim.keymap.set({"n", "v"}, "<leader>d", "\"_d")
vim.keymap.set("x", "<leader>d", "\"_dP")

-- copy and paste from clipboard
vim.keymap.set("n", "<leader>pp", "\"+p")
vim.keymap.set({"v", "n"}, "<leader>y", "\"+y")

-- quicklist navigation
vim.keymap.set("n", "<C-k>", ":cprev<CR>zz")
vim.keymap.set("n", "<C-j>", ":cnext<CR>zz")
vim.keymap.set("n", "<leader><C-k>", ":lprev<CR>zz")
vim.keymap.set("n", "<leader><C-j>", ":lnext<CR>zz")

vim.keymap.set("n", "<leader>w", "<cmd>write<cr>")

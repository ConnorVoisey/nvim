
vim.g.mapleader = " "

-- move selected up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

-- view up or down half a page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- copy to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")

-- lsp format
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- traverse errors
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- find and replace current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- edit nvim config
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim<CR>");

-- Reload nvim config and sync plugins
vim.keymap.set("n", "<leader>SO", function()
    vim.cmd("so")
    vim.cmd("Lazy sync")
end)

-- comment selection (native gc operator, built into Neovim since 0.10)
vim.keymap.set("v", "<leader>/", "gc", { remap = true });

-- toggle relative line numbers
vim.keymap.set({"n", "v"}, "<leader>l", "<cmd>set rnu!<CR>");

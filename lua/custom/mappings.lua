local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<Tab>", "<cmd> bnext <CR>", { desc = "Move to next buffer" })
map("n", "<S-Tab>", "<cmd> bprev <CR>", { desc = "Move to previous buffer" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

map("n", "<leader>w", "<cmd>w<cr>", opts)
map("n", "<leader>q", "<cmd>q<cr>", opts)
map("n", "<leader>sv", "<cmd>source $MYVIMRC<cr>", opts)

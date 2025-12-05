require("harpoon").setup()


vim.keymap.set("n", "<C-e>", function()
	require("harpoon.ui").toggle_quick_menu()
end)

vim.keymap.set("n", "<leader>a", function()
	require("harpoon.mark").add_file()
end)
vim.keymap.set("n", "<leader>1", function()
	require("harpoon.ui").nav_next()
end)
vim.keymap.set("n", "<leader>2", function()
	require("harpoon.ui").nav_prev()
end)




vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.cursorcolumn = false
vim.undofile = true
vim.opt.undodir = os.getenv("USERPROFILE") .. "/.vim/undodir"
vim.incsearch = true
vim.opt.ignorecase = true
vim.opt.wrap = true
vim.opt.tabstop = 4
vim.o.shiftwidth = 4
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.swapfile = false
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
-- Picker para archivos
vim.keymap.set('n', '<leader>pf', ":Pick files<CR>")
vim.keymap.set('n', '<leader>ph', ":Pick help<CR>")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" }
})

--snips 
require("luasnip").setup({enable_autosnippets = true})
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require('luasnip')
local map = vim.keymap.set

map({"i"}, "<C-e>", function() ls.expand() end, {silent = true})
map({"i", "s"}, "<C-j>", function() ls.jump(1) end, {silent = true})
map({"i", "s"}, "<C-k>", function() ls.jump(-1) end, {silent = true})
require "mason".setup()
require "mini.pick".setup()
require "oil".setup()
vim.lsp.enable({ "lua_ls", "ts_ls" })


vim.api.nvim_create_autocmd('LspAttach', {

	group = vim.api.nvim_create_augroup('my.lsp', {}),

	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!

			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end

			client.server_capabilities.completionProvider.triggerCharacters = chars

			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,

})

vim.cmd [[set completeopt+=menuone,noselect,popup]]
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.cmd(":hi statusline guibg=NONE")

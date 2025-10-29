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
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim",          version = "0.1.8" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
})


require "marks".setup {
	builtin_marks = { "<", ">", "^" },
	refresh_interval = 250,
	sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	excluded_filetypes = {},
	excluded_buftypes = {},
	mappings = {}
}
--snips
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require('luasnip')
local map = vim.keymap.set

--treesitter
require 'nvim-treesitter.config'.setup({
	install_dir = vim.fn.stdpath('data') .. '/site',
	ensure_installed = { "elixir", "typescript", "javascript", "go", "r", "clangd", "astro", "heex", "eex", },
	highlight = { enable = true },
})


require 'nvim-treesitter'.install { 'rust', 'javascript', 'zig', 'lua', 'elixir', 'markdown', 'docker', 'makefile', 'vim',
	'typescript', 'json', 'yaml', 'html', 'css', 'tsx', 'go', 'heex', 'eex', 'c'
, 'r' }

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'rust', 'javascript', 'zig', 'lua', 'elixir', 'markdown', 'docker', 'makefile', 'vim',
		'typescript', 'json', 'yaml', 'html', 'css', 'tsx', 'go', 'heex', 'eex', 'c', 'r' },
	callback = function()
		vim.treesitter.start()
	end,
})



--telescope
local telescope = require("telescope")
telescope.setup({
	defaults = {
		preview = { treesitter = false },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = {
			"─", -- top
			"│", -- right
			"─", -- bottom
			"│", -- left
			"┌", -- top-left
			"┐", -- top-right
			"┘", -- bottom-right
			"└", -- bottom-left
		},
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		}
	}
})
telescope.load_extension("ui-select")

require("actions-preview").setup {
	backend = { "telescope" },
	extensions = { "env" },
	telescope = vim.tbl_extend(
		"force",
		require("telescope.themes").get_dropdown(), {}
	)
}
--oil
require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = {
		"icon",
		"permissions",
	},
	float = {
		max_width = 0.7,
		max_height = 0.6,
		border = "rounded",
	},

})


map({ "i" }, "<C-e>", function() ls.expand() end, { silent = true })
map({ "i", "s" }, "<C-j>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-k>", function() ls.jump(-1) end, { silent = true })
require "mason".setup()
require "mini.pick".setup()
vim.lsp.enable({ "lua_ls", "ts_ls", "gopls", "r_language_server", "clangd", "emmet_ls", "elixirls",
	"rust_analyzer" })


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

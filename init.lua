require("edward")
print(require("lazy.core.config").version)
-- basics
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.textwidth = 80
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.filetype.add({
	extension = {
		tmj = "json"
	}
})
vim.opt.fillchars = { vert = "│", horiz = "─", eob = " " }
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ffaa00", bg = "NONE", bold = true })
vim.api.nvim_set_option("clipboard", "unnamed")

-- configuration for telescope package (fuzzy finder)
local builtin = require('telescope.builtin')
-- fuzzy find
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
-- git fuzzy find
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- search
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<leader>gw', function()
	builtin.grep_string({ search = vim.fn.expand("<cword") });
end)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>lo', builtin.oldfiles, { desc = 'Telescope help tags' })

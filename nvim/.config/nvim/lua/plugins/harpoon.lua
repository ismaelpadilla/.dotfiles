return {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        vim.api.nvim_set_keymap('n', '<leader>ha', '<cmd>lua require("harpoon.mark").add_file()<CR>', {})
        vim.api.nvim_set_keymap('n', '<leader>hq', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', {})

        -- navigation
        vim.api.nvim_set_keymap('n', '<leader>hha', '<cmd>lua require("harpoon.ui").nav_file(1)<CR>', {})
        vim.api.nvim_set_keymap('n', '<leader>hhs', '<cmd>lua require("harpoon.ui").nav_file(2)<CR>', {})
        vim.api.nvim_set_keymap('n', '<leader>hhd', '<cmd>lua require("harpoon.ui").nav_file(3)<CR>', {})
        vim.api.nvim_set_keymap('n', '<leader>hhf', '<cmd>lua require("harpoon.ui").nav_file(4)<CR>', {})

        require("harpoon").setup({
            menu = {
                width = math.ceil(vim.api.nvim_win_get_width(0) / 2),
            }
        })

    end
}

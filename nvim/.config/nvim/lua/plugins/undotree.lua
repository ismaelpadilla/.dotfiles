return {
    "mbbill/undotree",
    config = function()
        vim.api.nvim_set_keymap('n', '<leader>u', '<cmd>UndotreeToggle<CR>', {})
    end
}

return {
    "tjdevries/colorbuddy.nvim",
    dependencies = { "Th3Whit3Wolf/onebuddy", {"catppuccin/nvim", name = "catppuccin"} },
    config = function()
        -- require('colorbuddy').colorscheme('onebuddy')
        -- require("colorbuddy").colorscheme("catppuccin")
        vim.cmd [[ colorscheme catppuccin-frappe ]]
    end
}

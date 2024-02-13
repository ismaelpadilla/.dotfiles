return {
    "tjdevries/colorbuddy.nvim",
    dependencies = { "Th3Whit3Wolf/onebuddy" },
    config = function()
        require("colorbuddy").colorscheme("onebuddy")
    end
}

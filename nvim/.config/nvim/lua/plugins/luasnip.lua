return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
        local ls = require('luasnip')

        vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(-1) end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-E>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { silent = true })

        local s = ls.s
        local fmt = require("luasnip.extras.fmt").fmt
        local i = ls.insert_node
        local rep = require("luasnip.extras").rep

        ls.add_snippets("all", {
            ls.parser.parse_snippet("expand", "-- this is what was expanded!")
        })
        ls.add_snippets("lua", {
            ls.parser.parse_snippet("rf", "local $1 = function($2)\n  $0\nend"),
            ls.parser.parse_snippet("tf", "local $1 = function($2)\n  $0\nend"),
            ls.parser.parse_snippet("mf", "local $1.$2 = function($3)\n  $0\nend"),
            s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })),
        })
    end
}

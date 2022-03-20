-- https://github.com/L3MON4D3/LuaSnip
local function prequire(...)
    local status, lib = pcall(require, ...)
    if (status) then return lib end
    return nil
end

local ls = prequire('luasnip')
local cmp = prequire("cmp")

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
    -- if cmp and cmp.visible() then
    --     cmp.select_next_item()
    -- elseif ls and ls.expand_or_jumpable() then
    --     return t("<Plug>luasnip-expand-or-jump")
    -- elseif check_back_space() then
    --     return t "<Tab>"
    -- else
    --     cmp.complete()
    -- end
    -- return ""
    if ls and ls.expand_or_jumpable() then
        return t("<Plug>luasnip-expand-or-jump")
    elseif check_back_space() then
        return t "<Tab>"
    else
        cmp.complete()
    end
    return ""
end
_G.s_tab_complete = function()
    -- if cmp and cmp.visible() then
    --     cmp.select_prev_item()
    -- elseif ls and ls.jumpable(-1) then
    if ls and ls.jumpable(-1) then
        return t("<Plug>luasnip-jump-prev")
    else
        return t "<S-Tab>"
    end
    return ""
end

ls.config.set_config {
    updateevents = "TextChanged,TextChangedI",
}

vim.api.nvim_set_keymap("i", "<c-k>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<c-k>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<c-j>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<c-j>", "v:lua.s_tab_complete()", { expr = true })
-- vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
-- vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

-- reload snippets
vim.api.nvim_set_keymap("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/luaconfig/luasnip.lua<CR>", {})

local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras").rep

ls.snippets = {
    all = {
        ls.parser.parse_snippet("expand", "-- this is what was expanded!"),
    },

    lua = {
        ls.parser.parse_snippet("lf", "local $1 = function($2)\n  $0\nend"),
        ls.parser.parse_snippet("mf", "local $1.$2 = function($3)\n  $0\nend"),
        s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })),
    }
}


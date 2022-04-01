require('comment_helper').setup({
    -- Enable luasnip snippets.
    -- Set to true if you have LuaSnip installed.
    luasnip_enabled = true,

    -- If luasnip isn't supported and we receive a snippet as a comment,
    -- attempt to turn it into text and insert it.
    snippets_to_text = false,

    -- Function to call after a comment is placed.
    post_hook = nil
})

vim.api.nvim_set_keymap('n', '<leader>cl', '<cmd> lua require("comment_helper").comment_line()<CR>', {})

local ch = require("comment_helper")
local ch_lua = require("comment_helper_lua")

ch.set_ignored_types("lua", {"chunk"})
ch.add("lua", "function_declaration", ch_lua.function_declaration)
ch.add("lua", "variable_declaration", ch_lua.variable_declaration)
ch.add("lua", "assignment_statement", ch_lua.assignment_statement)

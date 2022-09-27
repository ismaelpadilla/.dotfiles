require('telescope').setup {
    defaults = {
        file_ignore_patterns = { "dist", "node%_modules", "target" },
    },
    pickers = {
        find_files = {
            hidden = true
        },
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
        ["ui-select"] = {
            require("telescope.themes").get_ivy {
                -- even more opts
            },
            specific_opts = {
              -- codeactions = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
              -- },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
              -- codeactions = false,
            }
        }
    }
}
require('telescope').load_extension('fzy_native')
require("telescope").load_extension("ui-select")

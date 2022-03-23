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
        }
    }
}
require('telescope').load_extension('fzy_native')

require('telescope').setup {
    defaults = {
        initial_mode = normal,
        file_ignore_patterns = { "dist", "node%_modules", "target" }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}
require('telescope').load_extension('fzy_native')

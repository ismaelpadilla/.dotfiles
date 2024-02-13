local gs = require('gitsigns')

gs.setup({
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        map('n', '<leader>hb', function() gs.blame_line { full = true } end)
        map('n', '<leader>lb', function() gs.blame_line() end)
    end
})

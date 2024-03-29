local lspkind = require('lspkind')

-- Setup nvim-cmp. https://github.com/hrsh7th/nvim-cmp
local cmp = require 'cmp'

local home = os.getenv('HOME')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<C-k>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'nvim_lua' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'buffer' },
    }),

    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            -- mode = 'symbol', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            -- before = function (entry, vim_item)
            --   return vim_item
            -- end

            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]",
            }
        })
    },
    experimental = {
        ghost_text = false
    },
    view = {
        -- entries = "native"
    }
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--capabilities = capabilities
--}

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<space>CA', '<cmd>:CodeActionMenu<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>ql', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)
    buf_set_keymap('n', '<space>ll', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>fc', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

end

local servers = { 'pyright', 'tsserver', 'html', 'bashls' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150,
        },
        capabilities = capabilities
    }
end

-- rust tools, the options inside 'server' are the lsp options
require("rust-tools").setup({
    server = {
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150,
        },
        capabilities = capabilities
    }
})


--require'lspconfig'.sumneko_lua.setup{}
-- lua lsp, see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
--local system_name
--if vim.fn.has("mac") == 1 then
--
--  system_name = "macOS"
--elseif vim.fn.has("unix") == 1 then
--  system_name = "Linux"
--elseif vim.fn.has('win32') == 1 then
--  system_name = "Windows"
--else
--  print("Unsupported system for sumneko")
--end
--
-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local USER = vim.fn.expand('$USER')
local sumneko_root_path = home .. "/lualsp/lua-language-server/"
local sumneko_binary = sumneko_root_path .. "bin/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require('lspconfig').lua_ls.setup({
    on_attach = on_attach,
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua", "--preview" };
    -- capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

require("lspconfig").gopls.setup({
    on_attach = on_attach,
    cmd = { "gopls", "serve" },
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
})

-- local languageServerPath = vim.fn.stdpath("config").."/languageserver"
-- requires global installation of typescript @angular/language-service @angular/language-server
local languageServerPath = home .. "/.nvm/versions/node/v17.9.0/lib/"
-- local languageServerPath = vim.fn.getcwd() .. "/node-modules"
-- local path = os.execute
local cmd = { "ngserver", "--stdio", "--tsProbeLocations", languageServerPath, "--ngProbeLocations", languageServerPath,
    "--viewEngine" }
require 'lspconfig'.angularls.setup {
    cmd = cmd,
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
    on_new_config = function(new_config, new_root_dir)
        new_config.cmd = cmd
    end,
}

nvim_lsp.efm.setup {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    init_options = { documentFormatting = true },
    filetypes = { "python" },
    settings = {
        rootMarkers = { ".git/" },
        languages = {
            python = {
                { formatCommand = "black --quiet -", formatStdin = true }
            }
        }
    }
}

-- nvim-cmp highlight groups
local Group = require("colorbuddy.group").Group
local g = require("colorbuddy.group").groups
local c = require("colorbuddy.color").colors
-- local s = require("colorbuddy.style").styles

Group.new("CmpItemAbbrDeprecated", g.Error)
Group.new("CmpItemKind", c.red)
-- Group.new("CmpItemKind", g.Special)
Group.new("CmpItemMenu", g.NonText)

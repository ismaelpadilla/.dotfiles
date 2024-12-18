return {
    "neovim/nvim-lspconfig",
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/nvim-cmp',
        'onsails/lspkind-nvim',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        -- 'simrat39/rust-tools.nvim',
    },
    config = function()
        local lspkind = require('lspkind')

        -- Setup nvim-cmp. https://github.com/hrsh7th/nvim-cmp
        local cmp = require 'cmp'

        local home = os.getenv('HOME')
        local luasnip = require("luasnip")

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body) -- For `luasnip` users.
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
                ['<C-k>'] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.confirm({ select = true })
                    else
                        fallback()
                    end
                end),
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

        local nvim_lsp = require('lspconfig')

        local attach_lsp = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Mappings.
            local opts = { noremap = true, silent = true, buffer = ev.buf }

            -- See `:help vim.lsp.*` for documentation on any of the below functions
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            vim.keymap.set('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
            -- vim.keymap.set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
            -- vim.keymap.set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
            -- vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
            --     opts)
            vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            vim.keymap.set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            vim.keymap.set('n', '<space>CA', '<cmd>:CodeActionMenu<CR>', opts)
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            vim.keymap.set('n', '<space>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
            vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
            vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
            vim.keymap.set('n', '<space>ql', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)
            vim.keymap.set('n', '<space>ll', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
            vim.keymap.set('n', '<space>fc', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
        end

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                attach_lsp(ev)
            end
        })

        local servers = { 'pyright', 'ts_ls', 'html', 'bashls' }
        for _, lsp in ipairs(servers) do
            nvim_lsp[lsp].setup {
                flags = {
                    debounce_text_changes = 150,
                },
                capabilities = capabilities
            }
        end

        -- rust tools, the options inside 'server' are the lsp options
        -- require("rustaceanvim").setup({
        --     server = {
        --         flags = {
        --             debounce_text_changes = 150,
        --         },
        --         capabilities = capabilities
        --     }
        -- })


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
        local cmd = { "ngserver", "--stdio", "--tsProbeLocations", languageServerPath, "--ngProbeLocations",
            languageServerPath,
            "--viewEngine" }
        require 'lspconfig'.angularls.setup {
            cmd = cmd,
            flags = {
                debounce_text_changes = 150,
            },
            capabilities = capabilities,
            on_new_config = function(new_config, new_root_dir)
                new_config.cmd = cmd
            end,
        }

        nvim_lsp.efm.setup {
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
        -- local Group = require("colorbuddy.group").Group
        -- local g = require("colorbuddy.group").groups
        -- local c = require("colorbuddy.color").colors
        -- -- local s = require("colorbuddy.style").styles
        --
        -- Group.new("CmpItemAbbrDeprecated", g.Error)
        -- Group.new("CmpItemKind", c.red)
        -- -- Group.new("CmpItemKind", g.Special)
        -- Group.new("CmpItemMenu", g.NonText)
    end
}

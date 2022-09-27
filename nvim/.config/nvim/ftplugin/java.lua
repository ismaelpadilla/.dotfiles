local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
    return
end
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local home = os.getenv('HOME')
local java_debug_folder = home .. "/jdt/java-debug"
local vscode_java_test_folder = home .. "/jdt/vscode-java-test"
local root_markers = { 'gradlew', 'pom.xml' }
local root_dir = require('jdtls.setup').find_root(root_markers)

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t") -- https://github.com/mfussenegger/nvim-jdtls/wiki/Sample-Configurations
-- local project_name = '/.workspace' .. vim.fn.fnamemodify(root_dir, ":p:h:t") -- https://github.com/mfussenegger/nvim-jdtls/wiki/Sample-Configurations

-- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local workspace_dir = home .. '/.jdt-workspace/' .. project_name
-- local workspace_dir = '~/RepoGit/' .. 'analytics-services'

local extendedClientCapabilities = require('jdtls').extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local bundles = {
    vim.fn.glob(java_debug_folder .. "/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
};
vim.list_extend(bundles, vim.split(vim.fn.glob(vscode_java_test_folder .. "/server/*.jar"), "\n"))

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {

        -- 💀
        '/Users/ipadilla/.sdkman/candidates/java/17.0.4-amzn/bin/java', -- or '/path/to/java11_or_newer/bin/java'
        -- '/Users/ipadilla/.sdkman/candidates/java/11.0.16.1-ms/bin/java', -- or '/path/to/java11_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:' .. home .. '/jdt/lombok.jar',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        -- 💀
        '-jar', vim.fn.glob(home .. '/jdt/jdt-language-server-1.15.*/plugins/org.eclipse.equinox.launcher_*.jar'),
        -- '-jar', vim.fn.glob(home .. '/jdt/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_*.jar'),
        -- home ..
        --     '/jdt/jdt-language-server-1.9.0-202203031534/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
        -- Must point to the                                                     Change this to
        -- eclipse.jdt.ls installation                                           the actual version


        -- 💀
        -- '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
        '-configuration', vim.fn.glob(home .. '/jdt/jdt-language-server-1.15.*/config_mac'),
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        -- Must point to the                      Change to one of `linux`, `win` or `mac`
        -- eclipse.jdt.ls installation            Depending on your system.


        -- 💀
        -- See `data directory configuration` section in the README
        '-data', workspace_dir
    },

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    -- root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = home .. "/.sdkman/candidates/java/8.0.342-amzn/",
                        default = true,
                    },
                    {
                        name = "JavaSE-11",
                        path = home .. "/.sdkman/candidates/java/11.0.16.1-ms"
                    },
                    {
                        name = "JavaSE-17",
                        path = home .. "/.sdkman/candidates/java/17.0.4-amzn/",
                    },
                },
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            }, referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all", -- literals, all, none
                },
            },
            imports = { -- <- this
                gradle = {
                    enabled = true,
                    wrapper = {
                        enabled = true,
                        checksums = {
                            -- {
                            --     sha256 = 'ebb6eaf164c425ffe76f9744a324feb774e750d821ed212d4c41f452adea248e',
                            --     allowed = true
                            -- },
                            -- {
                            --     sha256 = '70239e6ca1f0d5e3b2808ef6d82390cf9ad58d3a3a0d271677a51d1b89475857',
                            --     allowed = true
                            -- },
                            -- {
                            --     sha256 = '91a239400bb638f36a1795d8fdf7939d532cdc7d794d1119b7261aac158b1e60',
                            --     allowed = true
                            -- },
                        },
                    }
                }
            }
        },
        signatureHelp = { enabled = true };
        contentProvider = { preferred = "fernflower" },
    },
    capabilities = capabilities,

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = bundles,
        extendedClientCapabilities = extendedClientCapabilities,
        -- https://github.com/mfussenegger/nvim-jdtls/discussions/249
        settings = {
            java = {
                imports = {
                    gradle = {
                        enabled = true,
                        wrapper = {
                            enabled = true,
                            checksums = {
                                -- {
                                --     sha256 = 'ebb6eaf164c425ffe76f9744a324feb774e750d821ed212d4c41f452adea248e',
                                --     allowed = true
                                -- },
                                -- {
                                --     sha256 = '70239e6ca1f0d5e3b2808ef6d82390cf9ad58d3a3a0d271677a51d1b89475857',
                                --     allowed = true
                                -- },
                                -- {
                                --     sha256 = '91a239400bb638f36a1795d8fdf7939d532cdc7d794d1119b7261aac158b1e60',
                                --     allowed = true
                                -- },
                            },
                        }
                    }
                }
            },
        }
    },
    on_attach = function(client, bufnr)
        -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
        -- you make during a debug session immediately.
        -- Remove the option if you do not want that.
        -- require('jdtls').setup_dap({ hotcodereplace = 'auto' })
        require('jdtls').setup_dap()
        require('jdtls').setup.add_commands()
        require("jdtls.dap").setup_dap_main_class_configs()
    end,
}
-- P(table.concat(config.cmd, " "))

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)


local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end

local function buf_set_option(...) vim.api.nvim_buf_set_option(0, ...) end

-- Enable completion triggered by <c-x><c-o>
buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

-- Mappings.
local opts = { noremap = true, silent = true }

-- See `:help vim.lsp.*` for documentation on any of the below functions
-- regurar nvim mappings
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
buf_set_keymap('n', '<space>fc', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

-- jdtls-specific
buf_set_keymap('v', '<space>lem', '<Esc><Cmd>lua require("jdtls").extract_method(true)<CR>', opts)

buf_set_keymap('n', '<space>cs', '<cmd>lua require("lint").try_lint()<CR>', opts)


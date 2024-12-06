return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'leoluz/nvim-dap-go',
        'theHamsta/nvim-dap-virtual-text',
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio',
        'mfussenegger/nvim-dap-python'
    },
    config = function()
        local map = function(lhs, rhs, desc)
            if desc then
                desc = "[DAP] " .. desc
            end

            vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
        end

        map("<F1>", require("dap").step_back, "step_back")
        map("<F2>", require("dap").step_into, "step_into")
        map("<F3>", require("dap").step_over, "step_over")
        map("<F4>", require("dap").step_out, "step_out")
        map("<F5>", require("dap").continue, "continue")

        map("<leader>db", require("dap").toggle_breakpoint)
        map("<leader>dB", function()
            require("dap").set_breakpoint(vim.fn.input "[DAP] Condition > ")
        end)

        map("<leader>de", require("dapui").eval)
        map("<leader>dE", function()
            require("dapui").eval(vim.fn.input "[DAP] Expression > ")
        end)

        map('<Leader>df', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
        end)

        map('<Leader>dh', function()
            require('dap.ui.widgets').hover()
        end)

        require("dap-go").setup()
        require("nvim-dap-virtual-text").setup()
        require("dapui").setup()
        require("dap-python").setup("python")

        local dap = require("dap")
        local dap_ui = require("dapui")
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dap_ui.open()
        end

        dap.listeners.before.event_terminated["dapui_config"] = function()
            dap_ui.close()
        end

        dap.listeners.before.event_exited["dapui_config"] = function()
            dap_ui.close()
        end

        for _, config in pairs(require('dap').configurations.python) do
            config.justMyCode = false
        end
    end
}

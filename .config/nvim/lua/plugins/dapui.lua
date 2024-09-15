local config = function()
    local settings = require("config.settings")

    -- vim.fn.sign_define("DapBreakpoint", {
    --     text = settings.icons.debugging.breakpoint,
    --     texthl = "DiagnosticSignError",
    --     linehl = "",
    --     numhl = "",
    -- })

    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup({
        layouts = {
            {
                elements = {
                    "scopes",
                    "watches",
                    "stacks",
                    "breakpoints",
                },
                size = 40,
                position = "right",
            },
            {
                elements = {
                    "repl",
                    "console",
                },
                size = 0.25,
                position = "bottom",
            },
        },
        controls = {
            enabled = true,
            element = "repl",
        },
        floating = {
            border = settings.ui.border,
        },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            {
                "nvim-neotest/nvim-nio",
            },
        },
        config = config,
    },
}

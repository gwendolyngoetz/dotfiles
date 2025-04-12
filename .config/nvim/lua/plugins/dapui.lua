return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            {
                "nvim-neotest/nvim-nio",
            },
        },
        config = function()
            vim.diagnostic.config {
                signs = {
                    DapBreakpoint = {
                        text = require("config.settings").icons.debugging.breakpoint,
                        texthl = "DiagnosticSignError"
                    }
                }
            }

            require("dapui").setup({
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
            })

            require("dap").listeners.after.event_initialized["dapui_config"] = function()
                require("dapui").open()
            end

            require("dap").listeners.before.event_terminated["dapui_config"] = function()
                require("dapui").close()
            end

            require("dap").listeners.before.event_exited["dapui_config"] = function()
                require("dapui").close()
            end
        end
    },
}

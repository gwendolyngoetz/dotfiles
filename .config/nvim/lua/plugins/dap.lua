local config = function()
    local helpers = require("config.helpers")
    local dap = require("dap")


    -- Adapters: dotnet
    local ok_netcoredbg, netcoredbg_path = helpers.get_from_data_path("/mason/packages/netcoredbg/netcoredbg")

    if ok_netcoredbg then
        dap.adapters.coreclr = {
            type = "executable",
            command = netcoredbg_path,
            args = { "--interpreter=vscode" },
        }
    end

    --[[
    -- Adapters: Node and TypeScript
    local ok_node2, node2_path = helpers.get_from_data_path("/mason/packages/node-debug2-adapter/out/src/nodeDebug.js")

    if ok_node2 then
        dap.adapters.node2 = {
            type = "executable",
            command = "node",
            args = { node2_path },
        }
    end
    --]]

    --[[
    -- Adapters: Chrome
    local ok_chrome, chrome_path = helpers.get_from_data_path(
        "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js")

    if ok_chrome then
        dap.adapters.chrome = {
            type = "executable",
            command = "node",
            args = { chrome_path },
        }
    end
    --]]

    -- Configurations
    dap.configurations.javascript = {
        {
            name = "Launch Node",
            type = "node2",
            request = "launch",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
        },
    }

    dap.configurations.javascript = {
        {
            name = "Launch chrome",
            type = "chrome",
            request = "attach",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}",
        },
    }

    dap.configurations.cs = {
        {
            name = "Launch netcoredbg",
            type = "coreclr",
            request = "launch",
            program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
            end,
        },
    }

    --[[
  -- Looks for launch.json files in dotnet projects
  require("dap.ext.vscode").load_launchjs(nil, {
    coreclr = { "cs" },
  })
  --]]
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = config,
        keys = {
            { "<leader>du", "<cmd>lua require('dapui').toggle()<CR>",          { desc = "Toggle UI" } },
            { "<leader>dd", "<cmd>lua require('dap').repl.toggle()<CR>",       { desc = "Toggle Repl" } },
            { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" } },
            { "<leader>dl", "<cmd>lua require('dap').run_last()<CR>",          { desc = "Run Last" } },
            { "<leader>dt", "<cmd>lua require('dap').terminate()<CR>",         { desc = "Terminate" } },
            { "<leader>dq", "<cmd>lua require('dap').continue()<CR>",          { desc = "Continue" } },
            { "<leader>dw", "<cmd>lua require('dap').step_over()<CR>",         { desc = "Step Over" } },
            { "<leader>de", "<cmd>lua require('dap').step_info()<CR>",         { desc = "Step Into" } },
            { "<leader>dr", "<cmd>lua require('dap').step_out()<CR>",          { desc = "Step Out" } }
        }
    },
}

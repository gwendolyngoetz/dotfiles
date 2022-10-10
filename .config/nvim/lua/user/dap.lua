local helpers = require("helpers")

local dap = helpers.require("dap")
if not dap then
  return
end

local dapui = helpers.require("dapui")
if not dapui then
  return
end

dapui.setup({
  layouts = {
    {
      elements = {
        "scopes",
        "watches",
        "stacks",
        "breakpoints"
      },
      size = 40,
      position = "right"
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25,
      position = "bottom"
    }
  },
  controls = {
    enabled = true,
    element = "repl"
  }
})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local netcoredbg_path = helpers.get_from_data_path("/mason/bin/netcoredbg")

if helpers.is_empty(netcoredbg_path) then
  return
end

dap.adapters.coreclr = {
  type = 'executable',
  command = netcoredbg_path,
  args = {'--interpreter=vscode'}
}

--dap.configurations.cs = {
--  {
--    name = "launch - netcoredbg",
--    type = "coreclr",
--    request = "launch",
--    program = function ()
--      return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. 'ColorDisplay.Web/bin/Debug/net7.0/ColorDisplay.Web.dll', 'file')
--    end
--  }
--}

local dap_vscode = helpers.require("dap.ext.vscode")
if not dap_vscode then
  return
end

dap_vscode.load_launchjs(nil, {
  coreclr = {'cs'}
})


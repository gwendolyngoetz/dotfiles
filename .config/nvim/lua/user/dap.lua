local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
  return
end

local dapui_status_ok, dapui = pcall(require, "dapui")
if not dapui_status_ok then
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

dap.adapters.coreclr = {
  type = 'executable',
  command = '/home/gwendolyn/.local/share/nvim/mason/bin/netcoredbg',
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

local dap_vscode_status_ok, dap_vscode = pcall(require, "dap.ext.vscode")
if not dap_vscode_status_ok then
  return
end
dap_vscode.load_launchjs(nil, { coreclr = {'cs'}})

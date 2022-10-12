local helpers = require("helpers")

local dap = helpers.require("dap")
if not dap then
  return
end

-- Adapters: dotnet
local netcoredbg_path = helpers.get_from_data_path("/mason/bin/netcoredbg")

if not helpers.is_empty(netcoredbg_path) then
  dap.adapters.coreclr = {
    type = 'executable',
    command = netcoredbg_path,
    args = { '--interpreter=vscode' }
  }
end

-- Adapters: Node and TypeScript
local node2_path = helpers.get_from_data_path("/mason/packages/node-debug2-adapter/out/src/nodeDebug.js")

if not helpers.is_empty(node2_path) then
  dap.adapters.node2 = {
    type = 'executable';
    command = 'node',
    args = { node2_path };
  }
end

-- Adapters: Chrome
local chrome_path = helpers.get_from_data_path("/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js")

if not helpers.is_empty(chrome_path) then
  dap.adapters.chrome = {
    type = 'executable',
    command = 'node',
    args = { chrome_path };
  }
end

dap.configurations.javascript = {
  {
    type = 'node2';
    request = 'launch';
    program = '${file}';
    cwd = vim.fn.getcwd();
    sourceMaps = true;
    protocol = 'inspector';
    console = 'integratedTerminal';
  }
}

dap.configurations.javascript = {
  {
    type = 'chrome',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}'
  }
}

dap.configurations.javascriptreact = {
  {
    type = 'chrome',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}'
  }
}

dap.configurations.typescriptreact = {
  {
    type = 'chrome',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}'
  }
}

-- Looks for launch.json files in dotnet projects
require("dap.ext.vscode").load_launchjs(nil, {
  coreclr = { 'cs' }
})

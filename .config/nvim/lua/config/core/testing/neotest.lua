local helpers = require("config.helpers")

local neotest = helpers.require("neotest")
if not neotest then
  return
end

local lib = require("neotest.lib")
local DotnetNeotestAdapter = require("neotest-dotnet")
DotnetNeotestAdapter.root = lib.files.match_root_pattern("*.sln")

neotest.setup({
  adapters = {
    DotnetNeotestAdapter,
    --require("neotest-dotnet"),
    --require("neotest-python")({
    --  dap = { justMyCode = false },
    --}),
    --require("neotest-plenary"),
    --require("neotest-vim-test")({
    --  ignore_file_types = { "python", "vim", "lua" },
    --}),
  },
})

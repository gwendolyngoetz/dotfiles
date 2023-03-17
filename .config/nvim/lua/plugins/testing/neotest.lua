local config = function()
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
end

local features = require("config.features")

return {
  {
    "nvim-neotest/neotest",
    enabled = features.testing.neotest,
    commit = "21f4b94",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet",
    },
    config = config,
  },
  {
    "Issafalcon/neotest-dotnet",
    enabled = features.testing.neotest_dotnet,
    commit = "a90836a",
    dependencies = {
      "nvim-neotest/neotest",
    },
  },
}

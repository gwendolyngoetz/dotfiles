local M = {}

M.get_testing_commands = function()
  local ok_nvimtest, _ = pcall(require, "nvim-test")
  local ok_neotest, _ = pcall(require, "neotest")

  local is_set = false
  local commands = {}

  if ok_nvimtest then
    is_set = true
    commands = {
      a = { "<cmd>TestSuite<CR>", "Test All" },
      f = { "<cmd>TestFile<CR>", "Test File" },
      c = { "<cmd>TestNearest<CR>", "Test Nearest" },
      r = { "<cmd>TestLast<CR>", "Rerun Last Test" },
    }
  elseif ok_neotest then
    is_set = true
    commands = {
      f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", "Test File" },
      c = { "<cmd>lua require('neotest').run.run()<CR>", "Test Nearest" },
      d = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<CR>", "Debug File" },
      h = { "<cmd>lua require('neotest').output.open({ enter = true, short = false })<CR>", "Open Output" },
      r = { "<cmd>lua require('neotest').run.run_last()<CR>", "Rerun Last Test" },
      s = { "<cmd>lua require('neotest').summary.toggle()<CR>", "Summary" },
      a = { "<cmd>lua require('neotest').diagnostic()<CR>", "diagnostic" },
    }
  end

  return is_set, commands
end
M.setup = function()
  local ok_nvimtest, _ = pcall(require, "nvim-test")
  local ok_neotest, _ = pcall(require, "neotest")

  if ok_nvimtest then
    require("user.testing.nvim-test")
  elseif ok_neotest then
    require("user.testing.neotest")
  end
end

return M

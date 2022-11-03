local helpers = require("helpers")
local settings = require("settings")
local icons = settings.icons

local which_key = helpers.require("which-key")
if not which_key then
  return
end

local setup = {
  icons = {
    breadcrumb = icons.whichkey.breadcrumb,
    separator = icons.whichkey.separator,
    group = icons.whichkey.group,
  },
  window = {
    border = settings.ui.border,
  },
  ignore_missing = true,
}

-- Tree
local _, treetoggle_cmd = require("generic-tree").get_treetoggle_command()

local telescope = {
  show_keymaps = function()
    require("telescope.builtin").keymaps()
  end,

  show_commands = function()
    require("telescope.builtin").commands()
  end,

  show_registers = function()
    require("telescope.builtin").registers()
  end,

  show_help_tags = function()
    require("telescope.builtin").help_tags()
  end,

  show_oldfiles = function()
    require("telescope.builtin").oldfiles()
  end,

  show_find_files = function()
    require("telescope.builtin").find_files()
  end,

  show_live_grep = function()
    require("telescope.builtin").live_grep()
  end,

  show_buffers = function()
    require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({ previewer = false }))
  end,

  show_projects = function()
    require("telescope").extensions.projects.projects()
  end,

  show_notifications = function()
    require("telescope").extensions.notify.notify()
  end,

  show_workspace_diagnostics = function()
    require("telescope.builtin").diagnostics()
  end,

  show_buffer_diagnostics = function()
    require("telescope.builtin").diagnostics({ bufnr = 0 })
  end,

  show_git_status = function()
    require("telescope.builtin").git_status()
  end,

  show_git_branches = function()
    require("telescope.builtin").git_branches()
  end,

  show_git_commits = function()
    require("telescope.builtin").git_commits()
  end,
}

local git = {
  lazygit = function()
    _LAZYGIT_TOGGLE()
  end,

  next_hunk = function()
    require("gitsigns").next_hunk()
  end,
  prev_hunk = function()
    require("gitsigns").prev_hunk()
  end,

  blame_line = function()
    require("gitsigns").blame_line()
  end,

  preview_hunk = function()
    require("gitsigns").preview_hunk()
  end,

  reset_hunk = function()
    require("gitsigns").reset_hunk()
  end,

  reset_buffer = function()
    require("gitsigns").reset_buffer()
  end,

  stage_hunk = function()
    require("gitsigns").stage_hunk()
  end,

  undo_stage_hunk = function()
    require("gitsigns").undo_stage_hunk()
  end,

  diff_buffer = function()
    vim.api.nvim_command("Gitsigns diffthis HEAD")
  end,
}

local lsp = {
  info = function()
    vim.api.nvim_command("LspInfo")
  end,

  installer_info = function()
    vim.api.nvim_command("LspInstallInfo")
  end,

  code_action = function()
    vim.lsp.buf.code_action()
  end,

  format_code = function()
    vim.lsp.buf.format({ async = true })
  end,

  goto_next = function()
    vim.lsp.diagnostic.goto_next()
  end,

  goto_prev = function()
    vim.lsp.diagnostic.goto_prev()
  end,

  codelens_run = function()
    vim.lsp.codelens.run()
  end,

  set_loclist = function()
    vim.lsp.diagnostic.set_loclist()
  end,

  rename = function()
    vim.lsp.buf.rename()
  end,
}

local dap = {
  repl_toggle = function()
    require("dap").repl.toggle()
  end,

  run_last = function()
    require("dap").run_last()
  end,

  ui_toggle = function()
    require("dapui").toggle()
  end,

  terminate = function()
    require("dap").terminate()
  end,

  continue = function()
    require("dap").continue()
  end,

  toggle_breakpoint = function()
    require("dap").toggle_breakpoint()
  end,

  step_over = function()
    require("dap").step_over()
  end,

  step_into = function()
    require("dap").step_into()
  end,

  step_out = function()
    require("dap").step_out()
  end,
}

local neotest = {
  test_nearest = function()
    require("neotest").run.run()
  end,

  test_file = function()
    require("neotest").run.run(vim.fn.expand("%"))
  end,

  debug_file = function()
    require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
  end,

  open_output = function()
    require("neotest").output.open({ enter = true, short = false })
  end,

  rerun_last_test = function()
    require("neotest").run.run_last()
  end,

  show_summary = function()
    require("neotest").summary.toggle()
  end,

  show_diagnostic = function()
    require("neotest").diagnostic()
  end,
}

local nvimtest = {
  run_test_suite = function()
    vim.api.nvim_command("TestSuite")
  end,

  test_nearest = function()
    vim.api.nvim_command("TestNearest")
  end,

  test_file = function()
    vim.api.nvim_command("TestFile")
  end,

  rerun_last_test = function()
    vim.api.nvim_command("TestLast")
  end,
}

local mappings = {
  b = { telescope.show_buffers, "Buffers" },
  e = { treetoggle_cmd, "Explorer" },
  w = { "<cmd>w!<CR>", "Save" },
  q = { "<cmd>q!<CR>", "Quit" },
  c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
  h = { "<cmd>nohlsearch<CR>", "No Highlight" },
  F = { telescope.show_live_grep, "Find Text" },
  P = { telescope.show_projects, "Projects" },

  g = {
    name = "Git",
    g = { git.lazygit, "Lazygit" },
    j = { git.next_hunk, "Next Hunk" },
    k = { git.prev_hunk, "Prev Hunk" },
    l = { git.blame_line, "Blame" },
    p = { git.preview_hunk, "Preview Hunk" },
    r = { git.reset_hunk, "Reset Hunk" },
    R = { git.reset_buffer, "Reset Buffer" },
    s = { telescope.show_git_status, "Git Status" },
    S = { git.stage_hunk, "Stage Hunk" },
    u = { git.undo_stage_hunk, "Undo Stage Hunk" },
    b = { telescope.show_git_branches, "Checkout branch" },
    c = { telescope.show_git_commits, "Checkout commit" },
    d = { git.diff_buffer, "Diff" },
  },

  l = {
    name = "LSP",
    a = { lsp.code_action, "Code Action" },
    d = { telescope.show_buffer_diagnostics, "Document Diagnostics" },
    w = { telescope.show_workspace_diagnostics, "Workspace Diagnostics" },
    f = { lsp.format_code, "Format" },
    i = { lsp.info, "Info" },
    I = { lsp.installer_info, "Installer Info" },
    j = { lsp.goto_next, "Next Diagnostic" },
    k = { lsp.goto_prev, "Prev Diagnostic" },
    l = { lsp.codelens_run, "CodeLens Action" },
    q = { lsp.set_loclist, "Quickfix" },
    r = { lsp.rename, "Rename" },
  },

  f = {
    name = "Find",
    f = { telescope.show_find_files, "Find in Files" },
    g = { telescope.show_live_grep, "Live Grep" },
    b = { telescope.show_buffers, "Buffers" },
    m = { telescope.show_notifications, "Messages" },
    d = { telescope.show_buffer_diagnostics, "Diagnostics - Buffer" },
    D = { telescope.show_workspace_diagnostics, "Diagnostics - Workspace" },
    h = { telescope.show_help_tags, "Find Help" },
    r = { telescope.show_oldfiles, "Open Recent File" },
    R = { telescope.show_registers, "Registers" },
    k = { telescope.show_keymaps, "Keymaps" },
    C = { telescope.show_commands, "Commands" },
  },

  d = {
    name = "Debugging",
    b = { dap.toggle_breakpoint, "Toggle Breakpoint" },
    r = { dap.repl_toggle, "Toggle REPL" },
    l = { dap.run_last, "Run Last" },
    s = { dap.ui_toggle, "Toggle UI" },
    t = { dap.terminate, "Terminate" },
    --1 = { dap.continue, "Continue" },
    --2 = { dap.step_over, "Step Over" },
    --3 = { dap.step_into, "Step Into" },
    --5 = { dap.step_out, "Step Out" },
  },

  t = {
    name = "Testing",
    a = { nvimtest.run_test_suite, "Test All" },
    f = { nvimtest.test_file, "Test File" },
    c = { nvimtest.test_nearest, "Test Nearest" },
    r = { nvimtest.rerun_last_test, "Rerun Last Test" },

    --f = { neotest.test_file, "Test File" },
    --c = { neotest.test_nearest, "Test Nearest" },
    --d = { neotest.debug_file, "Debug File" },
    --h = { neotest.open_output, "Open Output" },
    --r = { neotest.rerun_last_test, "Rerun Last Test" },
    --s = { neotest.show_summary, "Summary" },
    --a = { neotest.show_diagnostic(), "diagnostic" },
  },

  --T = {
  --  name = "Terminal",
  --  n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
  --  u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
  --  t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
  --  p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
  --  f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
  --  h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
  --},
}

which_key.setup(setup)
which_key.register(mappings, {
  prefix = "<leader>",
  nowait = true,
})

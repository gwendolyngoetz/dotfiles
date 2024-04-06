local M = {
  global = {
    quit = function()
      vim.api.nvim_command("q!")
    end,

    save = function()
      vim.api.nvim_command("w!")
    end,

    close_buffer = function()
      vim.api.nvim_command("Bdelete!")
    end,
  },

  telescope = {
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

    show_worktrees = function()
      require("telescope").extensions.git_worktree.git_worktrees()
    end,

    show_create_worktree = function()
      require("telescope").extensions.git_worktree.create_git_worktree()
    end,

    show_buffers2 = function()
      vim.api.nvim_command("Telescope buffers")
    end,

    show_live_grep_ivy = function()
      vim.api.nvim_command("Telescope live_grep theme=ivy")
    end,
  },

  git = {
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
  },

  harpoon = {
    add_file = function()
      require("harpoon.mark").add_file()
    end,

    toggle_ui = function()
      require("harpoon.ui").toggle_quick_menu()
    end,
  },

  lsp = {
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
        vim.diagnostic.setloclist()
    end,

    rename = function()
      vim.lsp.buf.rename()
    end,
  },

  dap = {
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
  },

  nvimtest = {
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
  },
}

return M

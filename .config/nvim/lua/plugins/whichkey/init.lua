local config = function()
  local helpers = require("config.helpers")
  local settings = require("config.settings")
  local features = require("config.features")
  local icons = settings.icons

  local which_key = helpers.require("which-key")
  if not which_key then
    return
  end

  local functions = require("plugins.whichkey.whichkey-functions")

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
    disable = {
      filetypes = {
        "TelescopePrompt",
        "neo-tree",
      },
    },
  }

  local mappings = {
    w = { functions.global.save, "Save" },
    q = { functions.global.quit, "Quit" },
    c = { functions.global.close_buffer, "Close Buffer" },
    h = { functions.global.no_highlight, "No Highlight" },
  }

  if features.project then
    mappings["P"] = { functions.telescope.show_projects, "Projects" }
  end

  if features.gitsigns then
    mappings["g"] = {
      name = "Git",
      g = { functions.git.lazygit, "Lazygit" },
      j = { functions.git.next_hunk, "Next Hunk" },
      k = { functions.git.prev_hunk, "Prev Hunk" },
      l = { functions.git.blame_line, "Blame" },
      p = { functions.git.preview_hunk, "Preview Hunk" },
      r = { functions.git.reset_hunk, "Reset Hunk" },
      R = { functions.git.reset_buffer, "Reset Buffer" },
      s = { functions.telescope.show_git_status, "Git Status" },
      S = { functions.git.stage_hunk, "Stage Hunk" },
      u = { functions.git.undo_stage_hunk, "Undo Stage Hunk" },
      b = { functions.telescope.show_git_branches, "Checkout branch" },
      c = { functions.telescope.show_git_commits, "Checkout commit" },
      d = { functions.git.diff_buffer, "Diff" },
    }
  end

  if features.lsp then
    mappings["l"] = {
      name = "LSP",
      a = { functions.lsp.code_action, "Code Action" },
      d = { functions.telescope.show_buffer_diagnostics, "Document Diagnostics" },
      w = { functions.telescope.show_workspace_diagnostics, "Workspace Diagnostics" },
      f = { functions.lsp.format_code, "Format" },
      i = { functions.lsp.info, "Info" },
      I = { functions.lsp.installer_info, "Installer Info" },
      j = { functions.lsp.goto_next, "Next Diagnostic" },
      k = { functions.lsp.goto_prev, "Prev Diagnostic" },
      l = { functions.lsp.codelens_run, "CodeLens Action" },
      q = { functions.lsp.set_loclist, "Quickfix" },
      r = { functions.lsp.rename, "Rename" },
    }
  end

  if features.telescope then
    mappings["b"] = { functions.telescope.show_buffers, "Buffers" }
    mappings["F"] = { functions.telescope.show_live_grep_ivy, "Find Text" }

    mappings["f"] = {
      name = "Find",
      f = { functions.telescope.show_find_files, "Find in Files" },
      g = { functions.telescope.show_live_grep, "Live Grep" },
      b = { functions.telescope.show_buffers2, "Buffers" },
      m = { functions.telescope.show_notifications, "Messages" },
      d = { functions.telescope.show_buffer_diagnostics, "Diagnostics - Buffer" },
      D = { functions.telescope.show_workspace_diagnostics, "Diagnostics - Workspace" },
      h = { functions.telescope.show_help_tags, "Find Help" },
      r = { functions.telescope.show_oldfiles, "Open Recent File" },
      R = { functions.telescope.show_registers, "Registers" },
      k = { functions.telescope.show_keymaps, "Keymaps" },
      C = { functions.telescope.show_commands, "Commands" },
    }
  end

  if features.worktree then
    mappings["W"] = {
      name = "WorkTrees",
      ["l"] = { functions.telescope.show_worktrees, "List" },
      ["c"] = { functions.telescope.show_create_worktree, "Create" },
    }
  end

  if features.dap then
    mappings["d"] = {
      name = "Debugging",
      b = { functions.dap.toggle_breakpoint, "Toggle Breakpoint" },
      r = { functions.dap.repl_toggle, "Toggle REPL" },
      l = { functions.dap.run_last, "Run Last" },
      s = { functions.dap.ui_toggle, "Toggle UI" },
      t = { functions.dap.terminate, "Terminate" },
      -- 1 = { functions.dap.continue, "Continue" },
      -- 2 = { functions.dap.step_over, "Step Over" },
      -- 3 = { functions.dap.step_into, "Step Into" },
      -- 5 = { functions.dap.step_out, "Step Out" },
    }
  end

  local treetoggle_enabled, treetoggle_cmd = require("plugins.tree.generic-tree").get_treetoggle_command()
  if treetoggle_enabled then
    mappings["e"] = { treetoggle_cmd, "Explorer" }
  end

  local testing_enabled, testing_cmds = require("plugins.testing.generic-testing").get_testing_commands()
  if testing_enabled then
    mappings["t"] = vim.tbl_extend("keep", { name = "Testing" }, testing_cmds)
  end

  if features.toggleterm then
    mappings["T"] = {
      name = "Terminal",
      f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
      h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    }
  end

  which_key.setup(setup)
  which_key.register(mappings, {
    prefix = "<leader>",
    nowait = true,
  })
end

local features = require("config.features")

return {
  {
    "folke/which-key.nvim",
    enabled = features.whichkey,
    commit = "d871f2b",
    config = config,
  },
}

local config = function()
  local helpers = require("config.helpers")
  local settings = require("config.settings")
  local features = require("config.features")
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
    disable = {
      filetypes = {
        "TelescopePrompt",
        "neo-tree",
      },
    },
  }

  local mappings = {
    w = { "<cmd>w!<CR>", "Save" },
    q = { "<cmd>q!<CR>", "Quit" },
    c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
    h = { "<cmd>nohlsearch<CR>", "No Highlight" },
  }

  if features.project then
    mappings["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" }
  end

  if features.gitsigns then
    mappings["g"] = {
      name = "Git",
      g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
      j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
      k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
      l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
      p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
      r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
      R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
      s = { "<cmd>Telescope git_status<cr>", "Git Status" },
      S = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
      u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
      b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
      c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
      d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
    }
  end

  if features.lsp then
    mappings["l"] = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics" },
      w = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
      f = { "<cmd>lua vim.lsp.buf.format { async = true }<cr>", "Format" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
      j = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Next Diagnostic" },
      k = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
      l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
      q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    }
  end

  if features.telescope then
    mappings["b"] = {
      "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      "Buffers",
    }

    mappings["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" }

    mappings["f"] = {
      name = "Find",
      f = { "<cmd>Telescope find_files<CR>", "Find in Files" },
      g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
      b = { "<cmd>Telescope buffers<CR>", "Buffers" },
      m = { "<cmd>lua require('telescope').extensions.notify.notify()<CR>", "Messages" },
      d = { "<cmd>lua require('telescope.builtin').diagnostics({bufnr=0})<CR>", "Diagnostics - Buffer" },
      D = { "<cmd>Telescope diagnostics<CR>", "Diagnostics - Workspace" },
      h = { "<cmd>Telescope help_tags<CR>", "Find Help" },
      r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
      R = { "<cmd>Telescope registers<CR>", "Registers" },
      k = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
      C = { "<cmd>Telescope commands<CR>", "Commands" },
    }

    if features.worktree then
      mappings["f"]["w"] = { "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", "WorkTree" }
    end
  end

  if features.dap then
    mappings["d"] = {
      name = "Debugging",
      b = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle Breakpoint" },
      r = { "<cmd>lua require('dap').repl.toggle()<CR>", "Toggle REPL" },
      l = { "<cmd>lua require('dap').run_last()<CR>", "Run Last" },
      s = { "<cmd>lua require('dapui').toggle()<CR>", "Toggle UI" },
      t = { "<cmd>lua require('dap').terminate()<CR>", "Terminate" },
      --1 = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
      --2 = { "<cmd>lua require('dap').step_over()<CR>", "Step Over" },
      --3 = { "<cmd>lua require('dap').step_into()<CR>", "Step Into" },
      --5 = { "<cmd>lua require('dap').step_out()<CR>", "Step Out" },
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
    commit = "fb02773",
    --commit = "6885b66", -- see the error in messages here
    --commit = "fbf0381", -- started seeing vim.notify message here
    config = config,
  },
}

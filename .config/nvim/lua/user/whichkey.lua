local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
    },
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
    },
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  window = {
    border = "rounded", -- none, single, double, shadow
  },
  ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  ["b"] = { "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>", "Buffers" },
  ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
  ["w"] = { "<cmd>w!<CR>", "Save" },
  ["q"] = { "<cmd>q!<CR>", "Quit" },
  ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
  ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
  --["f"] = { "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", "Find files" },
  ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
  ["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },

  p = {
    name = "Packer",
    c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    s = { "<cmd>PackerSync<cr>", "Sync" },
    S = { "<cmd>PackerStatus<cr>", "Status" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
  },

  g = {
    name = "Git",
    g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
  },

  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics" },
    w = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
    f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
    j = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Next Diagnostic" },
    k = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
  },

  f = {
    name = "Find",
    f = { "<cmd>Telescope find_files<CR>", "Find in Files" },
    g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
    b = { "<cmd>Telescope buffers<CR>", "Buffers" },
    m = { "<cmd>lua require('telescope').extensions.notify.notify()<CR>", "Messages" },
    d = { "<cmd>lua require('telescope.builtin').diagnostics({bufnr=0})<CR>", "Diagnostics - Buffer" },
    D = { "<cmd>Telescope diagnostics<CR>", "Diagnostics - Workspace" },
    --b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
    h = { "<cmd>Telescope help_tags<CR>", "Find Help" },
    --M = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
    R = { "<cmd>Telescope registers<CR>", "Registers" },
    k = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
    C = { "<cmd>Telescope commands<CR>", "Commands" },
  },

  d = {
    name = "Debugging",
    b = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle Breakpoint" },
    r = { "<cmd>lua require('dap').repl_toggle()<CR>", "Toggle REPL" },
    l = { "<cmd>lua require('dap').run_last()<CR>", "Run Last" },
    s = { "<cmd>lua require('dapui').toggle()<CR>", "Toggle UI" },
    t = { "<cmd>lua require('dap').terminate()<CR>", "Terminate" },
    --1 = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
    --2 = { "<cmd>lua require('dap').step_over()<CR>", "Step Over" },
    --3 = { "<cmd>lua require('dap').step_into()<CR>", "Step Into" },
    --5 = { "<cmd>lua require('dap').step_out()<CR>", "Step Out" },
  },

  t = {
    name = "Testing",
    a = { "<cmd>TestSuite<CR>", "Test All" },
    f = { "<cmd>TestFile<CR>", "Test File" },
    c = { "<cmd>TestNearest<CR>", "Test Nearest" },
    r = { "<cmd>TestLast<CR>", "Rerun Last Test" },
  },

  --T = {
  --  name = "Terminal",
  --  n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
  --  u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
  --  t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
  --  p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
  --  f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
  --  h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
  --  v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
  --},
}

which_key.setup(setup)
which_key.register(mappings, opts)


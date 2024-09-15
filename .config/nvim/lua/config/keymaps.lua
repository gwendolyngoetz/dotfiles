--local { desc = "" } = { silent = true }

--Remap space as leader key
--vim.keymap.set("", "<Space>", "<Nop>", { desc = "" })

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")
vim.keymap.set("i", "<Up>", "<Nop>")
vim.keymap.set("i", "<Down>", "<Nop>")
vim.keymap.set("i", "<Left>", "<Nop>")
vim.keymap.set("i", "<Right>", "<Nop>")

-- Better window navigation
--vim.keymap.set("n", "<C-h>", "<C-w>h")
--vim.keymap.set("n", "<C-j>", "<C-w>j")
--vim.keymap.set("n", "<C-k>", "<C-w>k")
--vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<Left>", "<C-w>h")
vim.keymap.set("n", "<Down>", "<C-w>j")
vim.keymap.set("n", "<Up>", "<C-w>k")
vim.keymap.set("n", "<Right>", "<C-w>l")

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize up" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize down" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize left" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize right" })

-- Navigate buffers
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Navigate to next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Navigate to the previous buffer" })

-- Move text up and down
vim.keymap.set("n", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line up" })
vim.keymap.set("n", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line down" })

-- Clear highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Close buffers
vim.keymap.set("n", "<S-q>", "<cmd>Bdelete!<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<S-w>", "<cmd>Bdelete<CR>", { desc = "Close buffer" })

-- Better paste
vim.keymap.set("v", "p", '"_dP', { desc = "Paste" })

-- Folding
vim.keymap.set("n", "<leader>a", "za", { desc = "Toggle Fold" })

-- Visual - Stay in indent mode
vim.keymap.set("v", "<", "<gv", { desc = "Outdent" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent" })

-- Diagnostics
vim.keymap.set("n", "[d", "<cmd>vim.diagnostic.jump({ count = 1, float = true })<CR>", { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", "<cmd>vim.diagnostic.jump({ count = -1, float = true })<CR>", { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Plugins --

-- Tree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neotree" })

-- DAP
-- vim.keymap.set("n", "<leader>ds", "<cmd>lua require('dapui').toggle()<CR>", { desc = "Toggle UI" })
-- vim.keymap.set("n", "<leader>dd", "<cmd>lua require('dap').repl.toggle()<CR>", { desc = "Toggle Repl" })
-- vim.keymap.set("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
-- vim.keymap.set("n", "<leader>dl", "<cmd>lua require('dap').run_last()<CR>", { desc = "Run Last" })
-- vim.keymap.set("n", "<leader>dt", "<cmd>lua require('dap').terminate()<CR>", { desc = "Terminate" })
-- vim.keymap.set("n", "<leader>dq", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue" })
-- vim.keymap.set("n", "<leader>dw", "<cmd>lua require('dap').step_over()<CR>", { desc = "Step Over" })
-- vim.keymap.set("n", "<leader>de", "<cmd>lua require('dap').step_info()<CR>", { desc = "Step Into" })
-- vim.keymap.set("n", "<leader>dr", "<cmd>lua require('dap').step_out()<CR>", { desc = "Step Out" })


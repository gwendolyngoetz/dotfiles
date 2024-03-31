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
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

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
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

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
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Plugins --

-- Colorizer
vim.keymap.set("n", "<C-c>", "<cmd>ColorizerToggle<CR>", { desc = "Toggle Colorizer" })

-- Tree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neotree" })

-- Telescope
vim.keymap.set("n", "<leader>f", "<Nop>", { desc = "" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Find in files" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Show buffers" })
vim.keymap.set(
  "n",
  "<leader>fm",
  "<cmd>lua require('telescope').extensions.notify.notify()<CR>",
  { desc = "Show messages" }
)
vim.keymap.set(
  "n",
  "<leader>fd",
  "<cmd>lua require('telescope.builtin').diagnostics({bufnr=0})<CR>",
  { desc = "Show diagnostics" }
)
vim.keymap.set("n", "<leader>fD", "<cmd>Telescope diagnostics<CR>", { desc = "Show all diagnostics" })

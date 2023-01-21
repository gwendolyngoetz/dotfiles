-- stylua: ignore
local options = {
  backup         = false,
  clipboard      = "unnamed,unnamedplus",
  cmdheight      = 1,
  completeopt    = { "menu", "menuone", "noselect" },
  conceallevel   = 0,
  cursorline     = true,
  emoji          = false,
  expandtab      = true,
  fileencoding   = "utf-8",
  foldmethod     = "expr",
  foldexpr       = "nvim_treesitter#foldexpr()",
  foldlevel      = 9999,
  guifont        = "monospace:h17",
  hlsearch       = true,
  ignorecase     = true,
  laststatus     = 3,
  mouse          = "a",
  number         = true,
  numberwidth    = 4,
  pumheight      = 10,
  relativenumber = true,
  ruler          = false,
  scrolloff      = 8,
  shiftwidth     = 4,
  showcmd        = false,
  showmode       = false,
  showtabline    = 0,
  sidescrolloff  = 8,
  signcolumn     = "yes",
  smartcase      = true,
  smartindent    = true,
  splitbelow     = true,
  splitright     = true,
  swapfile       = false,
  tabstop        = 4,
  termguicolors  = true,
  timeoutlen     = 1000,
  undofile       = true,
  updatetime     = 300,
  wrap           = false,
  writebackup    = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.fillchars.eob = " "
vim.opt.iskeyword:append("-")
vim.opt.shortmess:append("c")
vim.opt.shortmess:remove("F") -- Disable for Metals
vim.opt.whichwrap:append("<,>,[,]")

vim.cmd("let g:loaded_perl_provider = 0")
vim.cmd("let g:loaded_ruby_provider = 0")

-- Color Scheme
--local colorscheme = "dracula"
local colorscheme = "tokyonight-night"

local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
if not status_ok then
  return
end

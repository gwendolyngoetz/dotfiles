local options = {
  backup         = false,
  clipboard      = "unnamed,unnamedplus",
  cmdheight      = 1,
  completeopt    = { "menuone", "noselect" },    -- mostly just for cmp
  conceallevel   = 0,                            -- so that `` is visible in markdown files
  cursorline     = true,                         -- highlight the current line
  emoji          = false,
  expandtab      = true,                         -- convert tabs to spaces
  fileencoding   = "utf-8",
  foldmethod     = "expr",
  foldexpr       = "nvim_treesitter#foldexpr()",
  foldlevel      = 9999,
  guifont        = "monospace:h17",
  hlsearch       = true,                         -- highlight all matches on previous search pattern
  ignorecase     = true,                         -- ignore case in search patterns
  laststatus     = 3,                            -- global status line
  mouse          = "a",
  number         = true,                         -- set numbered lines
  numberwidth    = 4,                            -- set number column width to 2 {default 4}
  pumheight      = 10,                           -- pop up menu height
  relativenumber = false,
  ruler          = false,
  scrolloff      = 8,
  shiftwidth     = 2,                            -- the number of spaces inserted for each indentation
  showcmd        = false,
  showmode       = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline    = 0,
  sidescrolloff  = 8,
  signcolumn     = "yes",
  smartcase      = true,
  smartindent    = true,
  splitbelow     = true,                         -- force all horizontal splits to go below current window
  splitright     = true,                         -- force all vertical splits to go to the right of current window
  swapfile       = false,
  tabstop        = 2,                            -- insert 2 spaces for a tab
  termguicolors  = true,
  timeoutlen     = 1000,                         -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile       = true,
  updatetime     = 300,                          -- faster completion (4000ms default)
  wrap           = false,                        -- display lines as one long line
  writebackup    = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.fillchars.eob=" "
vim.opt.iskeyword:append("-")
vim.opt.shortmess:append("c")
vim.opt.shortmess:remove("F") -- Disable for Metals
vim.opt.whichwrap:append("<,>,[,],h,l")

vim.cmd("let g:loaded_perl_provider = 0")
vim.cmd("let g:loaded_ruby_provider = 0")


-- Color Scheme
--local colorscheme = "dracula"
local colorscheme = "tokyonight-night"
vim.cmd("colorscheme " .. colorscheme)


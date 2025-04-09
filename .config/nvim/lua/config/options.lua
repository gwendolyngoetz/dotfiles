vim.opt.backup         = false
vim.opt.clipboard      = "unnamed,unnamedplus"
vim.opt.cmdheight      = 1
vim.opt.completeopt    = { "menu", "menuone", "popup", "fuzzy" }
vim.opt.conceallevel   = 0
vim.opt.cursorline     = true
vim.opt.emoji          = false
vim.opt.expandtab      = true
vim.opt.fileencoding   = "utf-8"
vim.opt.foldmethod     = "expr"
vim.opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel      = 9999
vim.opt.foldtext       = "v:lua.custom_foldtext()"
vim.opt.fillchars      = { eob = "-", fold = " " }
vim.opt.guifont        = "monospace:h17"
vim.opt.hlsearch       = true
vim.opt.ignorecase     = true
vim.opt.laststatus     = 3
vim.opt.list           = true
vim.opt.mouse          = "a"
vim.opt.number         = true
vim.opt.numberwidth    = 4
vim.opt.pumheight      = 10
vim.opt.relativenumber = true
vim.opt.ruler          = false
vim.opt.scrolloff      = 8
vim.opt.shiftwidth     = 4
vim.opt.showcmd        = false
vim.opt.showmode       = false
vim.opt.showtabline    = 0
vim.opt.sidescrolloff  = 8
vim.opt.signcolumn     = "yes"
vim.opt.smartcase      = true
vim.opt.smartindent    = true
vim.opt.splitbelow     = true
vim.opt.splitright     = true
vim.opt.swapfile       = false
vim.opt.tabstop        = 4
vim.opt.termguicolors  = true
vim.opt.timeoutlen     = 1000
vim.opt.undofile       = true
vim.opt.updatetime     = 250
vim.opt.wrap           = false
vim.opt.writebackup    = false
vim.opt.fillchars.eob  = " "
vim.opt.iskeyword:append("-")
vim.opt.shortmess:append("c")
vim.opt.shortmess:remove("F") -- Disable for Metals
vim.opt.whichwrap:append("<,>,[,]")

-- Must set leader and localleader before plugins
vim.g.mapleader            = vim.keycode("<space>")
vim.g.maplocalleader       = vim.keycode("<space>")

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.python3_host_prog    = '/usr/bin/python3'

vim.g.netrw_banner         = 0

function _G.custom_foldtext()
    local line = vim.fn.getline(vim.v.foldstart)
    return "" .. string.sub(tostring(line), 2)
end

--vim.opt.viewoptions:remove("options")

vim.opt.listchars = { -- NOTE: using `vim.opt` instead of `vim.o` to pass rich object
    tab = "▏ ",
    trail = "·",
    extends = "»",
    precedes = "«",
}

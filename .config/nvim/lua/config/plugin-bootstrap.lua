local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

local settings = require("config.settings")

local opts = {
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
    install = {
        colorscheme = { "tokoyonight-night" },
    },
    ui = {
        border = settings.ui.border,
        icons = settings.icons.lazy_nvim,
    },
    performance = {
        rtp = {
            paths = {}, -- add any custom paths here that you want to includes in the rtp
        },
    },
    rocks = {
        enabled = false
    }
}

require("lazy").setup("plugins", opts)

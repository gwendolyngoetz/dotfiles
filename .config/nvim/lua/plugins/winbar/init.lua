local config = function(_, opts)
    require("nvim-navic").setup(opts)

    vim.api.nvim_create_autocmd({
        "CursorMoved",
        --"BufWinEnter",
        "CursorHoldI",
        "CursorHold",
        "BufReadPost",
        "BufFilePost",
        "InsertEnter",
        "BufWritePost",
        "TabClosed",
        "TabEnter",
    }, {
        callback = function()
            require("plugins.winbar.winbar-mod").get_winbar()
        end,
    })
end

return {
    {
        "SmiteshP/nvim-navic",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = config,
        opts = {
            highlight = true,
            separator = " " .. require("config.settings").icons.chevron.right .. " ",
        }
    },
}

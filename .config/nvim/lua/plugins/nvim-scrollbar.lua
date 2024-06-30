local config = function()
    local helpers = require("config.helpers")

    local colors = helpers.require("tokyonight.colors")
    if not colors then
        return
    end

    require("scrollbar").setup({
        handle = {
            color = colors.bg_highlight,
        },
        marks = {
            Search = { color = colors.orange },
            Error = { color = colors.error },
            Warn = { color = colors.warning },
            Info = { color = colors.info },
            Hint = { color = colors.hint },
            Misc = { color = colors.purple },
        },
        handlers = {
            cursor = false,
        },
        excluded_filetypes = {
            "prompt",
            "TelescopePrompt",
            "noice",
            "neo-tree",
            "NvimTree",
            "mason",
        },
    })

    require("scrollbar.handlers.gitsigns").setup()
end

return {
    {
        "petertriho/nvim-scrollbar",
        dependencies = {
            "lewis6991/gitsigns.nvim",
        },
        config = config,
    },
}

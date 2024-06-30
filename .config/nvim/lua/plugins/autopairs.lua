local config = function()
    require("nvim-autopairs").setup({
        check_ts = true,
    })

    local on_confirm_done = require("nvim-autopairs.completion.cmp").on_confirm_done()
    require("cmp").event:on("confirm_done", on_confirm_done)
end

return {
    {
        "windwp/nvim-autopairs",
        config = config,
    },
}

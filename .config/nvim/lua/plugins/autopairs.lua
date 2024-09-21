return {
    {
        "windwp/nvim-autopairs",
        config = function (_, opts)
            require("nvim-autopairs").setup(opts)
            local on_confirm_done = require("nvim-autopairs.completion.cmp").on_confirm_done()
            require("cmp").event:on("confirm_done", on_confirm_done)
        end,
        opts = {
            check_ts = true
        }
    },
}

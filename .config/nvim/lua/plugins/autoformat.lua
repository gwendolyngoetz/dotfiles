return { -- Autoformat
    "stevearc/conform.nvim",
    opts = {
        notify_on_error = false,
        -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
        formatters_by_ft = {
            go = { "goimports", "gofumpt" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            lua = { "stylua --indent-type Spaces" },
            python = { "isort", "black" },
            terraform = { "terraform_fmt" },
            xml = { "xmlformat" },
        },
    },
    keys = {
        { "<leader>F", "<cmd>lua require('conform').format()<CR>", desc = "Format" }
    }
}

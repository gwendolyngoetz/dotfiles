local prettier = { "prettierd", "prettier", stop_after_first = true }
-- local prettier = { "prettierd", "eslint_d" }

return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters = {
            isort = {
                prepend_args = { "--profile", "black" },
            },
            stylua = {
                prepend_args = { "--indent-type", "Spaces" },
            },
        },
        -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
        formatters_by_ft = {
            cs = { "csharpier" },
            css = prettier,
            go = { "goimports", "gofumpt" },
            html = prettier,
            java = { "google-java-format" },
            javascript = prettier,
            javascriptreact = prettier,
            json = prettier,
            lua = { "stylua" },
            markdown = prettier,
            python = { "isort", "black" },
            sass = prettier,
            scala = { "scalafmt" },
            scss = prettier,
            sh = { "shfmt", "shellcheck" },
            sql = { "sql_formatter" },
            terraform = { "terraform_fmt" },
            typescript = prettier,
            typescriptreact = prettier,
            xml = { "xmlformat" },
            yaml = prettier,
        },
        format_on_save = {
            timeout_ms = 2000,
            lsp_format = "fallback",
        },
    },
    -- keys = {
    --     { "<leader>f", "<cmd>lua require('conform').format()<CR>", desc = "Format" }
    -- }
}

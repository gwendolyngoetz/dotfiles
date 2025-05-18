local prettier = { "prettierd", "prettier", stop_after_first = true }
-- local prettier = { "prettierd", "eslint_d" }

return {
    "stevearc/conform.nvim",
    opts = {
        notify_on_error = true,
        formatters = {
            csharpier = {
                command = vim.fn.stdpath('data') .. '/mason/bin/csharpier',
                args = { "format" },
                stdin = true
            }
        },
        -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
        formatters_by_ft = {
            cs = { "csharpier" },
            css = prettier,
            go = { "goimports", "gofumpt" },
            java = { "google-java-format" },
            javascript = prettier,
            json = prettier,
            html = prettier,
            lua = { "stylua --indent-type Spaces" },
            md = prettier,
            python = { "isort", "black" },
            sass = prettier,
            scala = { "scalafmt" },
            scss = prettier,
            sql = { "sql_formatter" },
            sh = { "shfmt", "shellcheck" },
            terraform = { "terraform_fmt" },
            ts = prettier,
            xml = { "xmlformat" },
            yaml = prettier,
            yml = prettier
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback"
        },
    },
    -- keys = {
    --     { "<leader>f", "<cmd>lua require('conform').format()<CR>", desc = "Format" }
    -- }
}

return { -- Autoformat
    "stevearc/conform.nvim",
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            return {
                timeout_ms = 500,
                lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
            }
        end,
        -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
        formatters_by_ft = {
            go = { "goimports", "gofumpt" },
            javascript = { { "prettierd", "prettier" } },
            lua = { "stylua --indent-type Spaces" },
            python = { "isort", "black" },
            terraform = { "terraform_fmt" },
            xml = { "xmlformat" },
        },
    },
}

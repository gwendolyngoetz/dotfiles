local settings = require("config.settings")
local icons = settings.icons

local config = function()
    require("mason").setup({
        ui = {
            border = settings.ui.border,
            icons = {
                package_installed = icons.mason.package_installed,
                package_pending = icons.mason.package_pending,
                package_uninstalled = icons.mason.package_uninstalled,
            },
        },
    })
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason.nvim",
            },
            {
                "WhoIsSethDaniel/mason-tool-installer.nvim",
                opts = {
                    ensure_installed = {
                        -- LSP -------------------
                        "bash-language-server",
                        "css-lsp",
                        "docker-compose-language-service",
                        "dockerfile-language-server",
                        "eslint-lsp",
                        "gopls",
                        "html-lsp",
                        "jdtls",
                        "jq-lsp",
                        "json-lsp",
                        "lua-language-server",
                        -- "ocaml-lsp ",
                        "omnisharp",
                        "pyright",
                        "rust-analyzer",
                        "sqlls",
                        "terraform-ls",
                        "typescript-language-server",
                        "yaml-language-server",
                        "zls",

                        -- DAP -------------------
                        "firefox-debug-adapter",
                        "netcoredbg",

                        -- Linter ----------------
                        "shellcheck",

                        -- Formatter -------------
                        "black",
                        "csharpier",
                        "gofumpt",
                        "goimports",
                        "google-java-format",
                        "isort",
                        "prettier",
                        "sql-formatter",
                        "stylua",
                        "xmlformatter"
                    }
                }
            },
            -- {
            --     "jay-babu/mason-nvim-dap.nvim",
            -- },
            -- {
            --     "folke/lazydev.nvim",
            --     opts = {},
            -- },
        },
        config = config
    },
}

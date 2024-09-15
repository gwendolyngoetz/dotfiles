local helpers = require("config.helpers")
local settings = require("config.settings")
local icons = settings.icons

local setup_diagnostic_settings = function()
    local config = {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = settings.ui.border,
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = settings.ui.border,
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = settings.ui.border,
    })
end

local setup_icons = function()
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#db4b4b", bg = "#4a1717" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#e0af68", bg = "#4a3b21" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#0db9d7", bg = "#013d49" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#1abc9c", bg = "#05392e" })

    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
                [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
                [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
                [vim.diagnostic.severity.HINT] = icons.diagnostics.hint
            }
        }
    })
end

local setup_lsp_attach = function()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
            end

            --  To jump back, press <C-t>.
            map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
            map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
            map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
            map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
            map(
                "<leader>ws",
                require("telescope.builtin").lsp_dynamic_workspace_symbols,
                "[W]orkspace [S]ymbols"
            )
            map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
            map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
            map("K", vim.lsp.buf.hover, "Hover Documentation")
            map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

            local client = vim.lsp.get_client_by_id(event.data.client_id)

            if client ~= nil then
                local illuminate = helpers.require("illuminate")
                if illuminate then
                    illuminate.on_attach(client)
                end

                local navic = helpers.require("nvim-navic")
                if navic and client.name ~= "metals" and client.server_capabilities.documentSymbolProvider then
                    require("nvim-navic").attach(client, event.buf)
                end
            end
        end,
    })
end

local get_server = function()
    local servers = {
        -- Bash
        bashls = {},

        -- CSS
        cssls = {},

        -- Go
        gopls = {},

        -- Html
        html = {},

        -- Java
        --jdtls = {},

        -- Json
        jsonls = {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                },
            },
        },

        -- Lua
        lua_ls = {
            settings = {
                Lua = {
                    completion = {
                        callSnippet = "Replace",
                    },
                    diagnostics = {
                      -- globals = { "vim" },
                      disable = {
                        "missing-fields",
                      },
                    },
                    -- workspace = {
                    --   library = {
                    --     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    --     [vim.fn.stdpath("config") .. "/lua"] = true,
                    --   },
                    -- },
                    telemetry = {
                      enable = false,
                    },
                },
            },
        },

        -- Ocaml
        ocamllsp = {},

        -- C#/dotnet
        -- csharp_ls = {},
        omnisharp = {},

        -- Python
        pyright = {
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "off",
                    },
                },
            },
        },

        -- Rust
        rust_analyzer = {},

        -- SQL
        sqlls = {},

        -- Tailwind
        -- tailwindcss = {},

        -- Terraform
        terraformls = {},

        -- Typescript
        ts_ls = {},

        -- Yaml
        yamlls = {},
    }
    return servers
end

local config = function()
    setup_diagnostic_settings()
    setup_icons()
    setup_lsp_attach()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local servers = get_server()

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

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
        "black",
        -- "flake8",
        "gofumpt",
        "goimports",
        "isort",
        "prettier",
        "stylua",
        "xmlformatter"
    })

    require("lspconfig.ui.windows").default_options.border = settings.ui.border

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
        handlers = {
            function(server_name)
                local server = servers[server_name] or {}
                -- This handles overriding only values explicitly passed
                -- by the server configuration above. Useful when disabling
                -- certain features of an LSP (for example, turning off formatting for tsserver)
                server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                require("lspconfig")[server_name].setup(server)
            end,
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
                "williamboman/mason-lspconfig.nvim",
            },
            {
                "jay-babu/mason-nvim-dap.nvim",
            },
            {
                "WhoIsSethDaniel/mason-tool-installer.nvim",
            },
            {
                "j-hui/fidget.nvim",
                opts = {},
            },
            {
                "folke/lazydev.nvim",
                opts = {},
            },
        },
        config = config
    },
}

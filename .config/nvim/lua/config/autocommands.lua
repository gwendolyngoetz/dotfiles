-- Use 'q' to quit from common plugins
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir" },
    callback = function()
        vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
    end,
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Reset filetype for docker compose files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "compose.yaml", "compose.yml", "docker-compose.yaml", "docker-compose.yml" },
    callback = function()
        vim.opt.filetype = "yaml.docker-compose"
    end
})

-- Fixes Autocomment
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    callback = function()
        vim.cmd("set formatoptions-=cro")
    end,
})

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    callback = function()
        vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Hover diagnostics
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
        }
        vim.diagnostic.open_float(nil, opts)
    end,
})


-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        --  To jump back, press <C-t>.
        map("gd", require("snacks.picker").lsp_definitions, "[G]oto [D]efinition")
        map("gr", require("snacks.picker").lsp_references, "[G]oto [R]eferences")
        map("gi", require("snacks.picker").lsp_implementations, "[G]oto [I]mplementation")

        map("<leader>D", require("snacks.picker").lsp_type_definitions, "Type [D]efinition")
        map("<leader>ds", require("snacks.picker").lsp_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", require("snacks.picker").lsp_workspace_symbols, "[W]orkspace [S]ymbols")
        map("<leader>lr", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client:supports_method('textDocument/foldingRange') then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end


        -- -- Enable CodeLens if supported by the server
        -- if client.server_capabilities.codeLensProvider then
        --     -- Add keybinding to manually refresh CodeLens
        --     local opts = { buffer = event.buf, noremap = true, silent = true }
        --     vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
        --     vim.keymap.set('n', '<leader>cr', vim.lsp.codelens.refresh, opts)

        --     -- Automatically show CodeLens
        --     vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        --         buffer = event.buf,
        --         callback = vim.lsp.codelens.refresh
        --     })
        -- end
    end,
})

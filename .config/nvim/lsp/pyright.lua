---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off",
            },
        },
    }
}

-- vim.fn.stdpath('data') . '/mason/bin/lua-language-server'

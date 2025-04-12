---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
}

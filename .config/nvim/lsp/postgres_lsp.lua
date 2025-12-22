---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/postgres-language-server', 'lsp-proxy' },
    filetypes = {
        'sql',
    },
    root_markers = { 'postgrestools.jsonc' },
}

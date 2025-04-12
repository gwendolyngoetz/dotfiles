---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/sql-language-server', 'up', '--method', 'stdio' },
    filetypes = { 'sql', 'mysql' },
}

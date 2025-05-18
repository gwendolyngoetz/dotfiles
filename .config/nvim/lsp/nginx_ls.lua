---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/nginx-language-server' },
    filetypes = { 'nginx' },
    root_markers = { 'nginx.conf', '.git' },
}

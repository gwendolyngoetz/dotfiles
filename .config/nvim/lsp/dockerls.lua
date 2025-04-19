---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/docker-langserver', "--stdio" },
    filetypes = { 'dockerfile' },
    root_markers = { 'Dockerfile' },
}

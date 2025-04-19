---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/jq-lsp' },
    filetypes = { 'jq' },
    root_markers = { '.git' }
}

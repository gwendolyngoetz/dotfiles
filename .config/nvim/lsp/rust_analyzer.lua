---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/rust-analyzer' },
    filetypes = { 'rust' },
}

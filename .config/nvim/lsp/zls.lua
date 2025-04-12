---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/zls' },
    filetypes = { 'zig', 'zir' },
}

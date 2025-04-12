---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/typescript-language-server', "--stdio" },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.tsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx'
    },
    root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
}

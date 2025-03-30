return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/vscode-css-language-server', "--stdio" },
    filetypes = { 'css', 'scss', 'less' },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
}

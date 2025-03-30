return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/vscode-html-language-server', "--stdio" },
    filetypes = { 'html', 'templ' },
}

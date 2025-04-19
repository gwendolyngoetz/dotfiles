---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/vscode-css-language-server', "--stdio" },
    filetypes = { 'css', 'scss', 'less' },
    init_options = { provideFormatter = true },
    root_markers = { 'package.json', '.git' },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
}

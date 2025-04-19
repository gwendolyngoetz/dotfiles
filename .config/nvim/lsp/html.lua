---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/vscode-html-language-server', "--stdio" },
    filetypes = { 'html', 'templ' },
    root_markers = { 'package.json', '.git' },
    settings = {},
    init_options = {
        provideFormatter = true,
        embeddedLanguages = { css = true, javascript = true },
        configurationSection = { 'html', 'css', 'javascript' },
    },
}

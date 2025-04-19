---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
        '.git',
    },
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
            diagnostics = {
                globals = { "vim" },
                disable = {
                    "missing-fields",
                },
            },
            runtime = {
                version = 'LuaJIT'
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME
                },
            },
            telemetry = {
                enable = false
            }
        }
    }
}

-- Currently this is a opt in. Watch for later
-- when this is default and can be removed
vim.loader.enable()

-- -- Temporarily disable lsp file watcher due to performance issues
-- local ok, wf = pcall(require, "vim.lsp._watchfiles")
-- if ok then
--   wf._watchfunc = function()
--     return function() end
--   end
-- end

require("config.options")
require("config.plugin-bootstrap")
require("config.keymaps")
require("config.autocommands")
require("config.diagnostics")

vim.lsp.enable({
    'bashls',
    'cssls',
    'eslint',
    'dockercompose_ls',
    'dockerls',
    'gopls',
    'html',
    -- 'jdtls',
    'jqls',
    'jsonls',
    'lua_ls',
    -- 'nginx_ls',
    'ocamllsp',
    'omnisharp',
    'postgres_lsp',
    'pyright',
    'rust_analyzer',
    'sqlls',
    'terraformls',
    'ts_ls',
    'yamlls',
    'zls'
})

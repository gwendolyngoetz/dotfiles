---@type vim.lsp.Config
return {
  cmd = { vim.fn.stdpath('data') .. '/mason/bin/gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  -- root_markers = { '.luarc.json', '.luarc.jsonc' },
  -- settings = {
  -- }
}

-- vim.fn.stdpath('data') . '/mason/bin/' . 'lua-language-server'


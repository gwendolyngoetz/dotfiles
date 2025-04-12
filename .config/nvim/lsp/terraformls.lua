---@type vim.lsp.Config
return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/terraform-ls', 'serve' },
    filetypes = { 'terraform', 'terraform-vars' },
    root_markers = { '.git', '.terraform' },
    settings = {
        terraform = {
            ignoreSingleFileWarning = true
        }
    }
}

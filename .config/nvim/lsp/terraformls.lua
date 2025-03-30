return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/terraform-ls', 'serve' },
    filetypes = { 'terraform', 'terraform-vars' },
}

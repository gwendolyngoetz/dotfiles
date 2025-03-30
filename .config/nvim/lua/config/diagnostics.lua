local settings = require("config.settings")
local icons = settings.icons

-- diagnostic settings
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = settings.ui.border,
        source = true,
        header = "",
        prefix = "",
    },
})

-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.buf.with(vim.lsp.buf.hover, {
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = settings.ui.border,
})

-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.buf.with(vim.lsp.buf.signature_help, {
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = settings.ui.border,
})

-- setup icons
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#db4b4b", bg = "#4a1717" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#e0af68", bg = "#4a3b21" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#0db9d7", bg = "#013d49" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#1abc9c", bg = "#05392e" })

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.hint
        }
    }
})

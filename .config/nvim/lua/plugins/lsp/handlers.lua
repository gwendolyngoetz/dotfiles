local helpers = require("config.helpers")
local settings = require("config.settings")
local icons = settings.icons

local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.warn },
    { name = "DiagnosticSignHint", text = icons.diagnostics.hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.info },
  }

  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#db4b4b", bg = "#4a1717" })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#e0af68", bg = "#4a3b21" })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#0db9d7", bg = "#013d49" })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#1abc9c", bg = "#05392e" })

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = settings.ui.border,
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = settings.ui.border,
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = settings.ui.border,
  })
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
  keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<CR>", opts)
  keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<CR>", opts)
  keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", opts)
  keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>", opts)
  keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.name == "lua_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end

  lsp_keymaps(bufnr)

  if client.name == "jdt.ls" then
    vim.lsp.codelens.refresh()
    ---@diagnostic disable-next-line: undefined-global
    if JAVA_DAP_ACTIVE then
      require("jdtls").setup_dap({ hotcodereplace = "auto" })
      require("jdtls.dap").setup_dap_main_class_configs()
    end

    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.textDocument.completion.completionItem.snippetSupport = false
  end

  local illuminate = helpers.require("illuminate")
  if illuminate then
    illuminate.on_attach(client)
  end

  local navic = helpers.require("nvim-navic")
  if navic then
    navic.attach(client, bufnr)
  end
end

return M

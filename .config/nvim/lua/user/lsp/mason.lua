local helpers = require("helpers")
local settings = require("settings")
local icons = settings.icons

local mason = helpers.require("mason")
if not mason then
  return
end

local mason_lspconfig = helpers.require("mason-lspconfig")
if not mason_lspconfig then
  return
end

local lspconfig = helpers.require("lspconfig")
if not lspconfig then
  return
end

local servers = {
  "sumneko_lua",
  "cssls",
  "html",
  "tsserver",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "omnisharp",
  "gopls",
  "sqlls",
  "rust_analyzer",
  "terraformls",
}

mason.setup({
  ui = {
    border = settings.ui.border,
    icons = {
      package_installed = icons.mason.package_installed,
      package_pending = icons.mason.package_pending,
      package_uninstalled = icons.mason.package_uninstalled,
    },
  },
})

mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  server = vim.split(server, "@")[1]

  local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  lspconfig[server].setup(opts)
end

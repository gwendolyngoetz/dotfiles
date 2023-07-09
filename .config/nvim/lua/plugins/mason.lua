local config = function()
  local helpers = require("config.helpers")
  local settings = require("config.settings")
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
    "lua_ls",
    "cssls",
    "html",
    "tsserver",
    "pyright",
    "bashls",
    "jsonls",
    "jdtls",
    --"yamlls",
    --"omnisharp",
    "csharp_ls",
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

  require("lspconfig.ui.windows").default_options.border = settings.ui.border

  local opts = {}

  for _, server in pairs(servers) do
    opts = {
      on_attach = require("plugins.lsp.handlers").on_attach,
      capabilities = require("plugins.lsp.handlers").capabilities,
    }

    server = vim.split(server, "@")[1]

    local require_ok, conf_opts = pcall(require, "plugins.lsp.settings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", conf_opts, opts)
    end

    lspconfig[server].setup(opts)
  end
end

local features = require("config.features")

return {
  {
    "williamboman/mason.nvim",
    enabled = features.mason,
    commit = "5ad3e11",
    config = config,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = features.mason,
    commit = "82685fd",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    enabled = features.mason,
    commit = "ae0c5fa",
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = features.mason,
    commit = "e4d56b4",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
  },
}

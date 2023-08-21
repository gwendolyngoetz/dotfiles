local config = function()
  local settings = require("config.settings")
  local icons = settings.icons

  local servers = {
    "bashls",
    "csharp_ls",
    "cssls",
    "gopls",
    "html",
    "jdtls",
    "jsonls",
    "lua_ls",
    "ocamllsp",
    --"omnisharp",
    "pyright",
    "rust_analyzer",
    "sqlls",
    "terraformls",
    "tsserver",
    --"yamlls",
  }

  require("mason").setup({
    ui = {
      border = settings.ui.border,
      icons = {
        package_installed = icons.mason.package_installed,
        package_pending = icons.mason.package_pending,
        package_uninstalled = icons.mason.package_uninstalled,
      },
    },
  })

  require("mason-lspconfig").setup({
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

    require("lspconfig")[server].setup(opts)
  end
end

return {
  {
    "williamboman/mason.nvim",
    commit = "a51c2d0",
    config = config,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    commit = "2997f46",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    commit = "ae0c5fa",
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    commit = "6148b51",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
  },
}

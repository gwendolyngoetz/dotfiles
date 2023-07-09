local config = function()
  local helpers = require("config.helpers")

  local null_ls = helpers.require("null-ls")
  if not null_ls then
    return
  end

  local mason_null_ls = helpers.require("mason-null-ls")
  if not mason_null_ls then
    return
  end

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  -- https://github.com/prettier-solidity/prettier-plugin-solidity
  null_ls.setup({
    debug = false,
    sources = {
      formatting.prettier.with({
        extra_filetypes = { "toml" },
        extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      }),
      formatting.black.with({
        extra_args = { "--fast", "--line-length", "120" },
      }),
      formatting.stylua.with({
        extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      }),
      --formatting.google_java_format,
      diagnostics.flake8.with({
        extra_args = { "--max-line-length", "120" },
      }),
      formatting.goimports,
      formatting.gofumpt,
      formatting.terraform_fmt,
    },
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end,
  })

  mason_null_ls.setup({
    ensure_installed = {
      "gofumpt",
      "goimports",
      "prettier",
      "stylua",
      "black",
      "flake8",
      "terraform_fmt",
    },
    automatic_installation = true,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    commit = "deade69",
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    commit = "db09b6c",
    config = config,
  },
}

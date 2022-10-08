local helpers = require("helpers")

local null_ls = helpers.require("null-ls")
if not null_ls then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup {
  debug = false,
  sources = {
    formatting.prettier.with {
      extra_filetypes = { "toml" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    formatting.black.with { extra_args = { "--fast" } },
    formatting.stylua,
    formatting.google_java_format,
    diagnostics.flake8,
  },
}

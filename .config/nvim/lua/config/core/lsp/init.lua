local helpers = require("config.helpers")

local lspconfig = helpers.require("lspconfig")
if not lspconfig then
  return
end

require("config.core.lsp.mason")
require("config.core.lsp.handlers").setup()
require("config.core.lsp.null-ls")

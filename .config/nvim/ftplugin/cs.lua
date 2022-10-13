vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

vim.api.nvim_create_autocmd({ "LspAttach" }, {
  callback = function (args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      require("user.lsp.handlers").on_attach(client, bufnr)
  end,
})

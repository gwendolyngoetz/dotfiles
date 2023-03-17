local config = function()
  local helpers = require("config.helpers")

  local toggleterm = helpers.require("toggleterm")
  if not toggleterm then
    return
  end

  toggleterm.setup({
    size = 20,
    open_mapping = [[<c-\>]],
    shading_factor = 2,
    direction = "float",
    float_opts = {
      border = "curved",
    },
  })

  function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)

    --vim.api.nvim_buf_set_keymap(0, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    --vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
  end

  vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

  function _LAZYGIT_TOGGLE()
    lazygit:toggle()
  end
end

local features = require("config.features")

return {
  {
    "akinsho/toggleterm.nvim",
    enabled = features.toggleterm,
    commit = "fd63194",
    config = config,
  },
}
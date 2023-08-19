local config = function()
  require("nvim-autopairs").setup({
    check_ts = true,
    disable_filetype = { "TelescopePrompt" },
  })

  local on_confirm_done = require("nvim-autopairs.completion.cmp").on_confirm_done({})
  require("cmp").event:on("confirm_done", on_confirm_done)
end

return {
  {
    "windwp/nvim-autopairs",
    commit = "e8f7dd7",
    config = config,
  },
}

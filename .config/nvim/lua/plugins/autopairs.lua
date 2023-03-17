local config = function()
  local helpers = require("config.helpers")

  local autopairs = helpers.require("nvim-autopairs")
  if not autopairs then
    return
  end

  autopairs.setup({
    check_ts = true, -- treesitter integration
    disable_filetype = { "TelescopePrompt" },
  })

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")

  local cmp = helpers.require("cmp")
  if not cmp then
    return
  end

  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))
end

local features = require("config.features")

return {
  {
    "windwp/nvim-autopairs",
    enabled = features.autopairs and features.cmp,
    commit = "e755f36",
    config = config,
  },
}

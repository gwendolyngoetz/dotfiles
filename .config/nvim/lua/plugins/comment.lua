local config = function()
  require("Comment").setup({
    mappings = {
      basic = false,
      extra = false,
    },
  })

  require("config.helpers").nmap("<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>")
end

return {
  {
    "numToStr/Comment.nvim",
    commit = "176e85e",
    config = config,
    lazy = false,
  },
}

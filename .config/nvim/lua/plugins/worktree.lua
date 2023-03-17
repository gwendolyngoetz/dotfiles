local config = function()
  local helpers = require("config.helpers")

  local worktree = helpers.require("git-worktree")
  if not worktree then
    return
  end

  worktree.setup({
    change_directory_command = "cd",
    update_on_change = true,
    update_on_change_command = "e .",
    clearjumps_on_change = true,
    autopush = false,
  })

  local telescope = helpers.require("telescope")
  if not telescope then
    return
  end

  telescope.load_extension("git_worktree")
end

local features = require("config.features")

return {
  {
    "theprimeagen/git-worktree.nvim",
    enabled = features.worktree,
    commit = "d7f4e25",
    config = config,
  },
}

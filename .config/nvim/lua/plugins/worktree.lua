local config = function()
  require("git-worktree").setup({
    change_directory_command = "cd",
    update_on_change = true,
    update_on_change_command = "e .",
    clearjumps_on_change = true,
    autopush = false,
  })

  require("telescope").load_extension("git_worktree")
end

return {
  {
    "theprimeagen/git-worktree.nvim",
    commit = "d7f4e25",
    config = config,
  },
}

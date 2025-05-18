return {
    {
        "theprimeagen/git-worktree.nvim",
        enabled = false,
        config = function(_, opts)
            require("git-worktree").setup(opts)
            require("telescope").load_extension("git_worktree")
        end,
        opts = {
            change_directory_command = "cd",
            update_on_change = true,
            update_on_change_command = "e .",
            clearjumps_on_change = true,
            autopush = false,
        }
    },
}

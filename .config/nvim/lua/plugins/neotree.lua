local icons = require("config.settings").icons

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        tag = "3.31.1",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            close_if_last_window = false,
            popup_border_style = require("config.settings").ui.border,
            sources = {
                "filesystem",
            },
            log_level = "error",
            default_component_configs = {
                indent = {
                    expander_collapsed = icons.chevron.right,
                    expander_expanded = icons.chevron.down,
                },
                icon = {
                    folder_closed = icons.folder.default,
                    folder_open = icons.folder.open,
                    folder_empty = icons.folder.empty,
                },
                modified = {
                    symbol = icons.file.modified,
                },
                git_status = {
                    symbols = {
                        -- Change type
                        added = icons.diff.added,
                        deleted = icons.diff.removed,
                        modified = icons.diff.modified,
                        renamed = icons.git.renamed,
                        -- Status type
                        untracked = icons.git.untracked,
                        ignored = icons.git.ignored,
                        unstaged = icons.git.unstaged,
                        staged = icons.git.staged,
                        conflict = icons.git.unmerged,
                    },
                },
            },
            window = {
                width = 32,
            },
            filesystem = {
                filtered_items = {
                    show_hidden_count = false,
                    hide_dotfiles = false,
                    hide_by_name = {
                        "node_modules",
                    },
                    never_show = {
                        ".git",
                        ".DS_Store",
                        "thumbs.db",
                    },
                },
            },
        }
    },
}

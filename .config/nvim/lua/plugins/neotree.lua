local icons = require("config.settings").icons

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        tag = "3.26",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function(_, opts)
            -- Remove the deprecated commands from v1.x
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
            require("neo-tree").setup(opts)
        end,
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
                mappings = {
                    ["<space>"] = { "toggle_node", nowait = false },
                    ["<2-LeftMouse>"] = "open",
                    ["<cr>"] = "open",
                    ["<esc>"] = "revert_preview",
                    ["P"] = { "toggle_preview", config = { use_float = true } },
                    ["S"] = "open_split",
                    ["s"] = "open_vsplit",
                    ["t"] = "open_tabnew",
                    ["w"] = "open_with_window_picker",
                    ["C"] = "close_node",
                    ["z"] = "close_all_nodes",
                    ["R"] = "refresh",
                    ["a"] = "add",
                    ["A"] = "add_directory",
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["y"] = "copy_to_clipboard",
                    ["x"] = "cut_to_clipboard",
                    ["p"] = "paste_from_clipboard",
                    ["c"] = "copy",
                    ["m"] = "move",
                    ["q"] = "close_window",
                    ["?"] = "show_help",
                    ["<"] = "prev_source",
                    [">"] = "next_source",
                },
            },
            filesystem = {
                window = {
                    mappings = {
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                        ["/"] = "fuzzy_finder",
                        ["D"] = "fuzzy_finder_directory",
                        ["f"] = "filter_on_submit",
                        ["<C-x>"] = "clear_filter",
                        ["[g"] = "prev_git_modified",
                        ["]g"] = "next_git_modified",
                    },
                },
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

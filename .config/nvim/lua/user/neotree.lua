local helpers = require("helpers")
local settings = require("settings")
local icons = require("settings").icons

local neotree = helpers.require("neo-tree")
if not neotree then
  return
end

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

--vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
--vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
--vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
--vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

neotree.setup({
  close_if_last_window = true,
  popup_border_style = settings.ui.border,
  source_selector = {
    winbar = true,
    tab_labels = {
      filesystem = icons.neotree.files .. " Files",
      buffers = icons.neotree.buffer .. " Bufs",
      git_status = icons.neotree.git .. " Git",
    },
    truncation_character = icons.truncation_character, -- character to use when truncating the tab label
    padding = { left = 1, right = 1 },
  },
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
    position = "left",
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
        ".DS_Store",
        "thumbs.db",
      },
    },
  },
  buffers = {
    window = {
      mappings = {
        ["bd"] = "buffer_delete",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
      },
    },
  },
  git_status = {
    window = {
      position = "float",
      --position = "left",
      mappings = {
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
    },
  },
})

local helpers = require("helpers")
local icons = require("settings").icons

local nvim_tree = helpers.require("nvim-tree")
if not nvim_tree then
  return
end

local nvim_tree_config = helpers.require("nvim-tree.config")
if not nvim_tree_config then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  renderer = {
    root_folder_modifier = ":t",
    icons = {
      glyphs = {
        default = icons.nvimtree.default,
        symlink = icons.nvimtree.symlink,
        folder = {
          arrow_open = icons.folder.arrow_open,
          arrow_closed = icons.folder.arrow_closed,
          default = icons.folder.default,
          open = icons.folder.open,
          empty = icons.folder.empty,
          empty_open = icons.folder.empty_open,
          symlink = icons.folder.symlink,
          symlink_open = icons.folder.symlink_open,
        },
        git = {
          unstaged = icons.git.unstaged,
          staged = icons.git.staged,
          unmerged = icons.git.unmerged,
          renamed = icons.git.renamed,
          untracked = icons.git.untracked,
          deleted = icons.git.deleted,
          ignored = icons.git.ignored,
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = icons.diagnostics.hint,
      info = icons.diagnostics.info,
      warning = icons.diagnostics.warn,
      error = icons.diagnostics.error,
    },
  },
  view = {
    width = 30,
    side = "left",
    mappings = {
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
        { key = "h", cb = tree_cb("close_node") },
        { key = "v", cb = tree_cb("vsplit") },
      },
    },
  },
})

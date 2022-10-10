local M = {}

M.icons = {
  kind = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },
  debugging = {
    breakpoint = ""
  },
  git = {
    add = "▎",
    change = "▎",
    changedelete = "▎",
    delete = "契",
    topdelete = "契",
    branch = "",
    unstaged = "",
    staged = "S",
    unmerged = "",
    renamed = "➜",
    untracked = "U",
    deleted = "",
    ignored = "◌",
  },
  indent = {
    blankline_char = "▏",
  },
  diagnostics = {
    error = " ",
    warn = " ",
    hint = "",
    info = "",
  },
  diff = {
    added = " ",
    modified = " ",
    removed = " "
  },
  nvimtree = {
    default = "",
    symlink = "",
  },
  file = {
    icon = ""
  },
  folder = {
    arrow_open = "",
    arrow_closed = "",
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
    symlink_open = "",
  },
  telescope = {
    prompt_prefix = " ",
    selection_caret = " ",
  },
  whichkey = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
  mason = {
    package_installed = "✓",
    package_pending = "➜",
    package_uninstalled = "✗"
  }
}

M.ui = {
  border = "rounded"
}


return M

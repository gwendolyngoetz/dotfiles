local M = {}

M.features = {
  dashboard = {
    alpha = false,
    dashboard = true,
  },
}

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
    breakpoint = "",
  },
  git = {
    add = "▎",
    change = "▎",
    changedelete = "▎",
    delete = "契",
    topdelete = "契",
    branch = "",
    unstaged = "",
    staged = "",
    unmerged = "",
    renamed = "➜",
    untracked = "",
    deleted = "",
    ignored = "",
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
    removed = " ",
  },
  nvimtree = {
    default = "",
    symlink = "",
  },
  chevron = {
    down = "",
    left = "",
    right = "",
    up = "",
  },
  file = {
    icon = "",
    modified = "",
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
    package_uninstalled = "✗",
  },
  cmp = {
    lsp = "",
    lua = "",
    snippets = "",
    buffer = "﬘",
    path = "",
  },
  lualine = {
    language_server = "力",
    spaces = "",
  },
  winbar = {
    file_separator = ":",
  },
  ui = {
    left = "▏",
    right = "▕",
    middle = "│",
    lower_left_corner = "└",
  },
  truncation_character = "…", -- character to use when truncating the tab label
  neotree = {
    files = "",
    buffer = "﬘",
    git = "",
  },
  lazy_nvim = {
    cmd = " ",
    config = "",
    event = "",
    ft = " ",
    init = " ",
    import = " ",
    keys = " ",
    lazy = "󰒲 ",
    loaded = "●",
    not_loaded = "○",
    plugin = " ",
    runtime = " ",
    source = " ",
    start = "",
    task = "✔ ",
    list = {
      "●",
      "➜",
      "★",
      "‒",
    },
  },
}

M.ui = {
  border = "rounded",
}

return M

local helpers = require("helpers")
local icons = require("settings").icons

local lualine = helpers.require("lualine")
if not lualine then
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = {
    error = icons.diagnostics.error,
    warn = icons.diagnostics.warn,
  },
  colored = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = true,
  symbols = {
    added = icons.diff.added,
    modified = icons.diff.modified,
    removed = icons.diff.removed,
  },
  cond = hide_in_width,
}

local mode = {
  "mode",
  fmt = function(str)
    return string.sub(str, 1, 1)
  end,
}

local lspinfo = function()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })

  if #clients > 0 then
    return icons.lualine.language_server .. #clients
  end

  return ""
end

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = icons.git.branch,
}

local location = {
  "location",
  padding = 0,
}

-- cool function for progress
local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return icons.lualine.spaces .. " " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup({
  options = {
    globalstatus = true,
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { branch, diagnostics },
    lualine_b = { mode },
    lualine_c = { lspinfo },
    lualine_x = { diff, spaces, filetype },
    lualine_y = { location },
    lualine_z = { progress },
  },
})

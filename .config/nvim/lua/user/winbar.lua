local helpers = require("helpers")
local icons = require("settings").icons

local navic = helpers.require("nvim-navic")
if not navic then
  return
end

navic.setup {
  highlight = true,
  separator = " " .. icons.chevron.right .. " "
}

require("lspconfig").omnisharp.setup {
  on_attach = function(client, bufnr)
    navic.attach(client, bufnr)
  end
}

local M = {}

M.winbar_filetype_exclude = {
  "help",
  "startify",
  "dashboard",
  "packer",
  "neogitstatus",
  "NvimTree",
  "Trouble",
  "alpha",
  "lir",
  "Outline",
  "spectre_panel",
  "toggleterm",
}

local get_buf_option = function(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

local get_filename = function()
  local filename = vim.fn.expand "%:t"
  local extension = vim.fn.expand "%:e"

  if not helpers.is_empty(filename) then
    local file_icon, file_icon_color = require("nvim-web-devicons").get_icon_color(
      filename,
      extension,
      { default = true }
    )

    local hl_group = "FileIconColor" .. extension

    vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
    if helpers.is_empty(file_icon) then
      file_icon = icons.file.icon
      file_icon_color = ""
    end

    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#NavicText#" .. filename .. "%*"
  end
end

local get_navic = function()
  local navic_location = navic.get_location()

  if not navic.is_available() or navic_location == "error" then
    return ""
  end

  if not helpers.is_empty(navic_location) then
    return icons.chevron.right .. " " .. navic_location
  else
    return ""
  end
end

local excludes = function()
  if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return true
  end
  return false
end

M.get_winbar = function()
  if excludes() then
    return
  end

  local value = get_filename()

  local navic_added = false
  if not helpers.is_empty(value) then
    local navic_value = get_navic()
    value = value .. " " .. navic_value
    if not helpers.is_empty(navic_value) then
      navic_added = true
    end
  end

  if not helpers.is_empty(value) and get_buf_option "mod" then
    local mod = "%#LineNr#" .. "" .. "%*"
    if navic_added then
      value = value .. " " .. mod
    else
      value = value .. mod
    end
  end

  local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
  if not status_ok then
    return
  end
end

return M

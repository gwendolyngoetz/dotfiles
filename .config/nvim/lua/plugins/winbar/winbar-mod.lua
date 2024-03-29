local helpers = require("config.helpers")
local icons = require("config.settings").icons
local navic = require("nvim-navic")
local M = {}

local filetype_depth_settings = {
  lua = {
    depth_limit = 4,
    depth_limit_indicator = "",
  },
}

M.winbar_filetype_exclude = {
  "help",
  "startify",
  "neogitstatus",
  "neo-tree",
  "NvimTree",
  "Trouble",
  "lir",
  "Outline",
  "spectre_panel",
}

local get_buf_option = function(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_get_option_value, 0, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

local get_filename = function()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")

  if not helpers.is_empty(filename) then
    local file_icon, file_icon_color =
      require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

    local hl_group = "FileIconColor" .. extension
    local hl_text = "WinbarFileNameColor"

    if vim.fn.hlexists(hl_group) == true then
      vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
    end

    vim.api.nvim_set_hl(0, hl_text, { italic = true, bold = true })

    if helpers.is_empty(file_icon) then
      file_icon = icons.file.icon
      file_icon_color = ""
    end

    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#" .. hl_text .. "#" .. filename .. "%*"
  end
end

local get_navic = function()
  if not navic or not navic.is_available() then
    return ""
  end

  local navic_location = navic.get_location(filetype_depth_settings[vim.bo.filetype])

  if not navic_location == "error" then
    return ""
  end

  if not helpers.is_empty(navic_location) then
    return icons.winbar.file_separator .. " " .. navic_location
  else
    return ""
  end
end

local exclude = function()
  return vim.tbl_contains(M.winbar_filetype_exclude or {}, vim.bo.filetype)
end

local get_code_path_text = function()
  local value = get_filename()

  local navic_added = false
  if not helpers.is_empty(value) then
    local navic_value = get_navic()
    value = value .. " " .. navic_value
    if not helpers.is_empty(navic_value) then
      navic_added = true
    end
  end

  if not helpers.is_empty(value) and get_buf_option("mod") then
    local mod = "%#LineNr#" .. "" .. "%*"
    if navic_added then
      value = value .. " " .. mod
    else
      value = value .. mod
    end
  end

  return value
end

M.get_winbar = function()
  if exclude() then
    return
  end

  local value = get_code_path_text()

  local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
  if not status_ok then
    return
  end
end

return M

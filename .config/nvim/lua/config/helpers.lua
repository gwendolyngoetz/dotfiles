local M = {}

M.require = function(modname)
  local ok, module = pcall(require, modname)

  if not ok then
    vim.notify("Missing module: " .. modname)
    return nil
  end

  return module
end

M.get_from_data_path = function(part)
  local path = vim.fn.stdpath("data") .. part

  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    vim.notify("Missing: " .. path)
    return ""
  end

  return path
end

M.is_empty = function(value)
  return value == nil or value == ""
end

M.tbl_merge = function(...)
  local retval = {}
  local i = 0

  for _, tbl in ipairs({ ... }) do
    for _, value in ipairs(tbl) do
      i = i + 1
      retval[i] = value
    end
  end

  return retval
end

M.nmap = function(lhs, rhs)
  vim.api.nvim_set_keymap("n", lhs, rhs, { silent = true })
end

return M

local M = {}

M.require = function(modname)
  local ok, module = pcall(require, modname)

  if not ok then
    vim.notify("Missing module: " .. modname)
    return nil
  end

  return module
end

return M

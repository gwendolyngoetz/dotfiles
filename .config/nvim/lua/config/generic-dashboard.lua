local M = {}

M.setup = function()
  local ok_dashboard, _ = pcall(require, "dashboard")
  local ok_alpha, _ = pcall(require, "alpha")

  if ok_dashboard then
    require("config.core.dashboard.dashboard-nvim")
  elseif ok_alpha then
    require("config.core.dashboard.alpha")
  end
end

return M

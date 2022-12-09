local M = {}

M.setup = function()
  local ok_dashboard, _ = pcall(require, "dashboard")
  local ok_alpha, _ = pcall(require, "alpha")

  if ok_dashboard then
    require("user.dashboard.dashboard-nvim")
  elseif ok_alpha then
    require("user.dashboard.alpha")
  end
end

return M

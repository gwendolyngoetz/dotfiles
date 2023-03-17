local config = function()
  local helpers = require("config.helpers")

  local project = helpers.require("project_nvim")
  if not project then
    return
  end

  project.setup({
    manual_mode = true,
    detection_methods = { "pattern" },
    patterns = { ".git", "Makefile", "package.json" },
  })

  local telescope = helpers.require("telescope")
  if not telescope then
    return
  end

  telescope.load_extension("projects")
end

local features = require("config.features")

return {
  {
    "ahmedkhalf/project.nvim",
    enabled = features.project,
    commit = "1c2e9c9",
    config = config,
  },
}

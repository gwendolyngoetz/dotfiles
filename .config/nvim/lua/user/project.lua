local helpers = require("helpers")

local project = helpers.require("project_nvim")
if not project then
  return
end

project.setup({
	detection_methods = { "pattern" },
	patterns = { ".git", "Makefile", "package.json" },
})

local telescope = helpers.require("telescope")
if not telescope then
  return
end

telescope.load_extension('projects')

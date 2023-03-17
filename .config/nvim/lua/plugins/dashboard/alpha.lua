local config = function()
  local helpers = require("config.helpers")

  local alpha = helpers.require("alpha")
  if not alpha then
    return
  end

  local dashboard = require("alpha.themes.dashboard")
  dashboard.section.header.val = {
    [[      __//     ]],
    [[     /.__.\    ]],
    [[     \ \/ /    ]],
    [[  '__/    \    ]],
    [[   \-      )   ]],
    [[    \_____/    ]],
    [[ _____|_|_____ ]],
    [[      " "      ]],
  }

  dashboard.section.buttons.val = {
    dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
    dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("q", " " .. " Quit", ":qa<CR>"),
  }

  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"

  dashboard.opts.opts.noautocmd = true
  alpha.setup(dashboard.opts)
end

local features = require("config.features")

return {
  {
    "goolord/alpha-nvim",
    enabled = features.dashboard.alpha,
    commit = "21a0f25",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    config = config,
  },
}

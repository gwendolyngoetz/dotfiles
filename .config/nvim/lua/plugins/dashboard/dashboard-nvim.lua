local config = function()
  local helpers = require("config.helpers")

  local dashboard = helpers.require("dashboard")
  if not dashboard then
    return
  end

  dashboard.custom_header = {
    [[      __//     ]],
    [[     /.__.\    ]],
    [[     \ \/ /    ]],
    [[  '__/    \    ]],
    [[   \-      )   ]],
    [[    \_____/    ]],
    [[ _____|_|_____ ]],
    [[      " "      ]],
  }

  dashboard.custom_center = {
    {
      icon = " ",
      desc = " Recent files    ",
      shortcut = "r",
      action = "Telescope oldfiles",
    },
    {
      icon = " ",
      desc = " Quit            ",
      shortcut = "q",
      action = "qa",
    },
  }

  dashboard.custom_footer = {}
end

return {
  {
    "glepnir/dashboard-nvim",
    enabled = false,
    commit = "5ccce7b",
    config = config,
  },
}

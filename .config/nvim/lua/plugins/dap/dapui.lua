local config = function()
  local helpers = require("config.helpers")
  local settings = require("config.settings")
  local icons = settings.icons

  local dap = helpers.require("dap")
  if not dap then
    return
  end

  local dapui = helpers.require("dapui")
  if not dapui then
    return
  end

  vim.fn.sign_define("DapBreakpoint", {
    text = icons.debugging.breakpoint,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  })

  dapui.setup({
    layouts = {
      {
        elements = {
          "scopes",
          "watches",
          "stacks",
          "breakpoints",
        },
        size = 40,
        position = "right",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 0.25,
        position = "bottom",
      },
    },
    controls = {
      enabled = true,
      element = "repl",
    },
    floating = {
      border = settings.ui.border,
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

local features = require("config.features")

return {
  {
    "rcarriga/nvim-dap-ui",
    enabled = features.dap,
    commit = "bdb94e3",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = config,
  },
}

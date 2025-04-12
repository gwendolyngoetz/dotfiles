local config = function()
    local icons = require("config.settings").icons

    local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn" },
        symbols = {
            error = icons.diagnostics.error,
            warn = icons.diagnostics.warn,
        },
        colored = false,
        always_visible = true,
    }

    local diff = {
        "diff",
        colored = true,
        symbols = {
            added = icons.diff.added,
            modified = icons.diff.modified,
            removed = icons.diff.removed,
        },
        cond = function()
            return vim.fn.winwidth(0) > 80
        end,
    }

    local mode = {
        "mode",
        fmt = function(str)
            return string.sub(str, 1, 1)
        end,
    }

    local lspinfo = function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })

        if #clients == 0 then
            return ""
        end

        local names = vim.iter(clients)
            :map(function(client)
                local icon = require('nvim-web-devicons').get_icon_by_filetype(vim.bo.filetype, { default = true })
                local name = client.name:gsub("language.server", "ls")
                return icon or name
            end)
            :totable()

        -- return icons.lualine.language_server .. #clients
        return icons.lualine.language_server .. table.concat(names, ", ") .. " "
    end

    local filetype_exclusions = {
        "TelescopePrompt",
        "neo-tree",
    }

    local filetype = {
        "filetype",
        icons_enabled = false,
        icon = nil,
        fmt = function(str)
            if vim.tbl_contains(filetype_exclusions, str) then
                return ""
            end
            return str
        end,
    }

    local branch = {
        "branch",
        icons_enabled = true,
        icon = icons.git.branch,
    }

    local location = {
        "location",
        padding = 0,
    }

    -- cool function for progress
    local progress = function()
        local current_line = vim.fn.line(".")
        local total_lines = vim.fn.line("$")
        local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
        local line_ratio = current_line / total_lines
        local index = math.ceil(line_ratio * #chars)
        return chars[index]
    end

    local spaces = function()
        return icons.lualine.spaces .. " " .. vim.api.nvim_get_option_value("shiftwidth", {
            buf = 0,
        })
    end

    require("lualine").setup({
        options = {
            globalstatus = true,
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            always_divide_middle = true,
        },
        sections = {
            lualine_a = { branch, diagnostics },
            lualine_b = { mode },
            lualine_c = { lspinfo },
            lualine_x = { diff, spaces, filetype },
            lualine_y = { location },
            lualine_z = { progress },
        },
    })
end

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = config,
    },
}

local config = function()
    local icons = require("config.settings").icons
    local actions = require("telescope.actions")

    require("telescope").setup({
        defaults = {
            layout_strategy = "vertical",
            layout_config = {
                vertical = { width = 0.9 },
                horizontal = { width = 0.9 },
            },
            prompt_prefix = icons.telescope.prompt_prefix,
            selection_caret = icons.telescope.selection_caret,
            path_display = { "smart" },
            file_ignore_patterns = { ".git/", "node_modules" },
            mappings = {
                i = {
                    ["<Down>"] = actions.cycle_history_next,
                    ["<Up>"] = actions.cycle_history_prev,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        },
    })

    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
end

return {
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
        },
        config = config,
        keys = {
            { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", { desc = "[S]earch [F]iles" }},
            { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>", { desc = "[S]earch by [G]rep" }},
            { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>", { desc = "Show buffers" }},
            { "<leader>fk", "<cmd>lua require('telescope.builtin').keymaps()<CR>", { desc = "Show keymaps" }},
            { "<leader>fm", "<cmd>lua require('telescope').extensions.notify.notify()<CR>", { desc = "Show messages" }},
            { "<leader>fd", "<cmd>lua require('telescope.builtin').diagnostics({bufnr=-1})<CR>", { desc = "Show diagnostics" }},
            { "<leader>fD", "<cmd>Telescope diagnostics<CR>", { desc = "Show all diagnostics" }},
            { "<leader>sh", "<cmd>lua require('telescope.builtin').help_tags()<CR>", { desc = "[S]earch [H]elp" }},
            { "<leader>ss", "<cmd>lua require('telescope.builtin').builtin()<CR>", { desc = "[S]earch [S]elect Telescope" }},
            { "<leader>sw", "<cmd>lua require('telescope.builtin').grep_string()<CR>", { desc = "[S]earch current [W]ord" }},
            { "<leader>sr", "<cmd>lua require('telescope.builtin').resume()<CR>", { desc = "[S]earch [R]esume" }},
            { "<leader>s.", "<cmd>lua require('telescope.builtin').oldfiles()<CR>", { desc = '[S]earch Recent Files ("." for repeat)' }}

        }
    },
}

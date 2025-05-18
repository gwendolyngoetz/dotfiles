return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        picker = {

        }
    },
    keys = {
        { "<leader>ff", function() require("snacks.picker").files() end,              { desc = "Find Files" } },
        { "<leader>fg", function() require("snacks.picker").grep() end,               { desc = "Find by Grep" } },
        { "<leader>fb", function() require("snacks.picker").buffers() end,            { desc = "Find Buffers" } },
        { "<leader>fk", function() require("snacks.picker").keymaps() end,            { desc = "Find Keymaps" } },
        -- { "<leader>fm", "<cmd>lua require('telescope').extensions.notify.notify()<CR>",      { desc = "Show messages" } },
        { "<leader>fd", function() require("snacks.picker").diagnostics_buffer() end, { desc = "Show diagnostics" } },
        { "<leader>fd", function() require("snacks.picker").diagnostics() end,        { desc = "Show all diagnostics" } },
        { "<leader>sh", function() require("snacks.picker").help() end,               { desc = "Show help" } },
        { "<leader>ss", function() require("snacks.picker").commands() end,           { desc = "Search Snacks" } },
        { "<leader>sw", function() require("snacks.picker").grep_word() end,          { desc = "Search current word" } },
        { "<leader>sr", function() require("snacks.picker").resume() end,             { desc = "Search resume" } },
        { "<leader>s.", function() require("snacks.picker").recent() end,             { desc = "Search recent" } },

        -- git
        { "<leader>vl", function() require("snacks.picker").git_log() end,            { desc = "Show git log" } },
        { "<leader>vs", function() require("snacks.picker").git_status() end,         { desc = "Show git status" } },

    }
}

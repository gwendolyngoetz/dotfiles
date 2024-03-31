local config = function()
  local icons = require("config.settings").icons

  local cmp = require("cmp")
  local luasnip = require("luasnip")
  luasnip.config.setup({})

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    completion = {
      completeopt = "menu,menuone,noinsert",
    },

    mapping = cmp.mapping.preset.insert({
      -- Select the [n]ext item
      ["<C-n>"] = cmp.mapping.select_next_item(),
      -- Select the [p]revious item
      ["<C-p>"] = cmp.mapping.select_prev_item(),

      -- Scroll the documentation window [b]ack / [f]orward
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),

      -- Accept ([y]es) the completion.
      --  This will auto-import if your LSP supports it.
      --  This will expand snippets if the LSP sent a snippet.
      ["<C-y>"] = cmp.mapping.confirm({ select = true }),

      -- Manually trigger a completion from nvim-cmp.
      --  Generally you don't need this, because nvim-cmp will display
      --  completions whenever it has completion options available.
      ["<C-Space>"] = cmp.mapping.complete({}),

      -- Think of <c-l> as moving to the right of your snippet expansion.
      --  So if you have a snippet that's like:
      --  function $name($args)
      --    $body
      --  end
      --
      -- <c-l> will move you to the right of each of the expansion locations.
      -- <c-h> is similar, except moving you backwards.
      ["<C-l>"] = cmp.mapping(function()
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { "i", "s" }),
      ["<C-h>"] = cmp.mapping(function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { "i", "s" }),

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    }),

    formatting = {
      expandable_indicator = true,
      fields = { "abbr", "kind", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = icons.kind[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = icons.cmp.lsp,
          luasnip = icons.cmp.snippets,
          buffer = icons.cmp.buffer,
          path = icons.cmp.path,
          nvim_lua = icons.cmp.lua,
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    }),
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    experimental = {
      ghost_text = true,
    },
  })
end

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    commit = "97dc716",
    dependencies = {
      {
        "hrsh7th/cmp-buffer",
        commit = "3022dbc",
      },
      {
        "hrsh7th/cmp-path",
        commit = "91ff86c",
      },
      {
        "hrsh7th/cmp-nvim-lsp",
        commit = "5af77f5",
      },
      {
        "hrsh7th/cmp-nvim-lua",
        commit = "f12408b",
      },
      {
        "saadparwaiz1/cmp_luasnip",
        commit = "05a9ab2",
      },
      -- snippets
      {
        "L3MON4D3/LuaSnip",
        commit = "a7a4b46",
        build = (function()
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            commit = "dcd4a58",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
      },
    },
    config = config,
  },
}

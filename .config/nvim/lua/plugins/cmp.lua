local config = function()
  local helpers = require("config.helpers")
  local settings = require("config.settings")
  local icons = settings.icons

  local cmp = helpers.require("cmp")
  if not cmp then
    return
  end

  local luasnip = helpers.require("luasnip")
  if not luasnip then
    return
  end

  require("luasnip/loaders/from_vscode").lazy_load()

  local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },

    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    }),
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = settings.icons.kind[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = icons.cmp.lsp,
          luasnip = icons.cmp.snippets,
          buffer = icons.cmp.buffer,
          path = icons.cmp.path,
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    },
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
    commit = "2743dd9",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
    },
    config = config,
  },
  {
    "hrsh7th/cmp-buffer",
    commit = "3022dbc",
  },
  {
    "hrsh7th/cmp-path",
    commit = "91ff86c",
  },
  {
    "hrsh7th/cmp-cmdline",
    commit = "8ee981b",
  },
  {
    "saadparwaiz1/cmp_luasnip",
    commit = "1809552",
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    commit = "44b16d1",
  },
  {
    "hrsh7th/cmp-nvim-lua",
    commit = "f12408b",
  },
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    commit = "a658ae2",
  },
  {
    "rafamadriz/friendly-snippets",
    commit = "7f6681b",
  },
}

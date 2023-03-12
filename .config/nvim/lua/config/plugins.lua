local settings = require("config.settings")
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local compile_path = fn.stdpath("data") .. "/plugin/packer_compiled.lua"

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({
        border = settings.ui.border,
      })
    end,
  },
})

-- Install your plugins here
return packer.startup({
  function(use)
    use({
      "wbthomason/packer.nvim",
      commit = "1d0cf98",
    })

    use({
      "nvim-lua/popup.nvim",
      commit = "b7404d3",
    })

    use({
      "nvim-lua/plenary.nvim",
      commit = "253d348",
    })

    use({
      "windwp/nvim-autopairs",
      commit = "e755f36",
    })

    use({
      "windwp/nvim-ts-autotag",
      commit = "fdefe46",
    })

    use({
      "numToStr/Comment.nvim",
      commit = "8d3aa5c",
    })

    use({
      "JoosepAlviste/nvim-ts-context-commentstring",
      commit = "729d83e",
      requires = {
        "nvim-treesitter/nvim-treesitter",
      },
    })

    use({
      "kyazdani42/nvim-web-devicons",
      commit = "4af94fe",
    })

    use({
      "kyazdani42/nvim-tree.lua",
      disable = true,
      commit = "45d386a",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
    })

    use({
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
    })

    use({
      "akinsho/bufferline.nvim",
      disable = true,
      tag = "v3.5.0",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
    })

    use({
      "famiu/bufdelete.nvim",
      commit = "8933abc",
    })

    use({
      "nvim-lualine/lualine.nvim",
      commit = "e99d733",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
    })

    use({
      "akinsho/toggleterm.nvim",
      commit = "fd63194",
    })

    use({
      "ahmedkhalf/project.nvim",
      commit = "1c2e9c9",
    })

    use({
      "lewis6991/impatient.nvim",
      commit = "c90e273",
    })

    use({
      "lukas-reineke/indent-blankline.nvim",
      tag = "v2.20.4",
    })

    -- Colorschemes
    use({
      "Mofiqul/dracula.nvim",
      disable = true,
      commit = "7ff76dd",
    })

    use({
      "folke/tokyonight.nvim",
      commit = "3ebc29d",
    })

    --use({
    --  "uloco/bluloco.nvim",
    --  commit = "29b73b9",
    --  requires = { "rktjmp/lush.nvim" },
    --})

    -- cmp plugins
    use({
      "hrsh7th/nvim-cmp",
      commit = "feed47f",
    })

    use({
      "hrsh7th/cmp-buffer",
      commit = "3022dbc",
    })

    use({
      "hrsh7th/cmp-path",
      commit = "91ff86c",
    })

    use({
      "hrsh7th/cmp-cmdline",
      commit = "8fcc934",
    })

    use({
      "saadparwaiz1/cmp_luasnip",
      commit = "1809552",
    })

    use({
      "hrsh7th/cmp-nvim-lsp",
      commit = "0e6b2ed",
    })

    use({
      "hrsh7th/cmp-nvim-lua",
      commit = "f349163",
    })

    -- snippets
    use({
      "L3MON4D3/LuaSnip",
      commit = "4368577",
    })

    use({
      "rafamadriz/friendly-snippets",
      commit = "009887b",
    })

    -- Install Helper
    use({
      "williamboman/mason.nvim",
      commit = "e522255",
    })

    use({
      "williamboman/mason-lspconfig.nvim",
      commit = "a81503f",
      requires = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
      },
    })

    use({
      "jayp0521/mason-null-ls.nvim",
      commit = "4070ec7",
      requires = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
      },
    })

    use({
      "jayp0521/mason-nvim-dap",
      commit = "8c5d021",
      requires = {
        "williamboman/mason.nvim",
        "mfussenegger/nvim-dap",
      },
    })

    -- LSP
    use({
      "neovim/nvim-lspconfig",
      commit = "4bb0f18",
    })

    use({
      "jose-elias-alvarez/null-ls.nvim",
      commit = "e172e1e",
    })

    use({
      "RRethy/vim-illuminate",
      commit = "49062ab",
    })

    use({
      "SmiteshP/nvim-navic",
      commit = "cdd2453",
      requries = {
        "neovim/nvim-lspconfig",
      },
    })

    -- Treesitter
    use({
      "nvim-treesitter/nvim-treesitter",
      commit = "079a50f6",
      run = ":TSUpdate",
    })

    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      commit = "542e087",
      require = {
        "nvim-treesitter/nvim-treesitter",
      },
    })

    -- Telescope
    use({
      "nvim-telescope/telescope.nvim",
      commit = "a3f17d3",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    })

    -- Notifications
    use({
      "rcarriga/nvim-notify",
      commit = "281e4d7",
      requires = {
        "nvim-lua/plenary.nvim",
      },
    })

    -- Git
    use({
      "lewis6991/gitsigns.nvim",
      commit = "b1f9cf7",
    })

    -- Java/Scala
    use({
      "mfussenegger/nvim-jdtls",
      commit = "9fcc949",
    })

    use({
      "scalameta/nvim-metals",
      commit = "0da75dc",
      requires = {
        "nvim-lua/plenary.nvim",
      },
    })

    -- Debugging
    use({
      "mfussenegger/nvim-dap",
      commit = "7319607",
    })

    use({
      "rcarriga/nvim-dap-ui",
      commit = "bdb94e3",
    })

    -- Colorhightling
    use({
      "norcalli/nvim-colorizer.lua",
      commit = "36c610a",
    })

    -- Testing
    use({
      "klen/nvim-test",
      commit = "4e30d07",
    })

    use({
      "nvim-neotest/neotest",
      disable = true,
      commit = "21f4b94",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "Issafalcon/neotest-dotnet",
      },
    })

    use({
      "Issafalcon/neotest-dotnet",
      disable = true,
      commit = "a90836a",
      requires = {
        "nvim-neotest/neotest",
      },
    })

    -- Folding
    use({
      "anuvyklack/pretty-fold.nvim",
      commit = "a7d8b42",
    })

    -- Scrollbar
    use({
      "petertriho/nvim-scrollbar",
      commit = "75210c5",
      requires = {
        "lewis6991/gitsigns.nvim",
      },
    })

    -- Winsep
    use({
      "nvim-zh/colorful-winsep.nvim",
      commit = "4958d55",
    })

    -- Whichkey
    use({
      "folke/which-key.nvim",
      commit = "6885b66", -- see the error in messages here
      --commit = "fbf0381", -- started seeing vim.notify message here
    })

    -- Motions
    use({
      "jinh0/eyeliner.nvim",
      commit = "3658815",
    })

    -- Dashboard
    use({
      "goolord/alpha-nvim",
      disable = true,
      commit = "21a0f25",
      requires = {
        "nvim-tree/nvim-web-devicons",
      },
    })

    use({
      "glepnir/dashboard-nvim",
      disable = true,
      commit = "5ccce7b",
    })

    -- Worktree
    use({
      "theprimeagen/git-worktree.nvim",
      commit = "d7f4e25",
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
      require("packer").sync()
    end
  end,
  config = {
    compile_path = compile_path,
  },
})

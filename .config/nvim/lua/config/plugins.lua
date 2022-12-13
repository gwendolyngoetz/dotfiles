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
      commit = "6afb674",
    })

    use({
      "nvim-lua/popup.nvim",
      commit = "b7404d3",
    })

    use({
      "nvim-lua/plenary.nvim",
      commit = "4b7e520",
    })

    use({
      "windwp/nvim-autopairs",
      commit = "6b6e35f",
    })

    use({
      "windwp/nvim-ts-autotag",
      commit = "fdefe46",
    })

    use({
      "numToStr/Comment.nvim",
      commit = "ad7ffa8",
    })

    use({
      "JoosepAlviste/nvim-ts-context-commentstring",
      commit = "32d9627",
      requires = {
        "nvim-treesitter/nvim-treesitter",
      },
    })

    use({
      "kyazdani42/nvim-web-devicons",
      commit = "9061e2d",
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
      tag = "v3.*",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
    })

    use({
      "famiu/bufdelete.nvim",
      commit = "027d356",
    })

    use({
      "nvim-lualine/lualine.nvim",
      commit = "3325d5d",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
    })

    use({
      "akinsho/toggleterm.nvim",
      commit = "3ba6838",
    })

    use({
      "ahmedkhalf/project.nvim",
      commit = "685bc8e",
    })

    use({
      "lewis6991/impatient.nvim",
      commit = "b842e16",
    })

    use({
      "lukas-reineke/indent-blankline.nvim",
      tag = "v2.20.*",
    })

    -- Colorschemes
    use({
      "Mofiqul/dracula.nvim",
      disable = true,
      commit = "7ff76dd",
    })

    use({
      "folke/tokyonight.nvim",
      commit = "29e2c68",
    })

    -- cmp plugins
    use({
      "hrsh7th/nvim-cmp",
      commit = "9bb8ee6",
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
      commit = "c66c379",
    })

    use({
      "saadparwaiz1/cmp_luasnip",
      commit = "1809552",
    })

    use({
      "hrsh7th/cmp-nvim-lsp",
      commit = "78924d1",
    })

    use({
      "hrsh7th/cmp-nvim-lua",
      commit = "d276254",
    })

    -- snippets
    use({
      "L3MON4D3/LuaSnip",
      commit = "619796e",
    })

    use({
      "rafamadriz/friendly-snippets",
      commit = "c93311f",
    })

    -- Install Helper
    use({
      "williamboman/mason.nvim",
      commit = "b9e8c4a",
    })

    use({
      "williamboman/mason-lspconfig.nvim",
      commit = "a910b4d",
      requires = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
      },
    })

    use({
      "jayp0521/mason-null-ls.nvim",
      commit = "95cbfde",
      requires = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
      },
    })

    use({
      "jayp0521/mason-nvim-dap",
      commit = "777840e",
      requires = {
        "williamboman/mason.nvim",
        "mfussenegger/nvim-dap",
      },
    })

    -- LSP
    use({
      "neovim/nvim-lspconfig",
      commit = "5f4b1fa",
    })

    use({
      "jose-elias-alvarez/null-ls.nvim",
      commit = "1ac465b",
    })

    use({
      "RRethy/vim-illuminate",
      commit = "fb83d83",
    })

    use({
      "SmiteshP/nvim-navic",
      commit = "2fad334",
      requries = {
        "neovim/nvim-lspconfig",
      },
    })

    -- Treesitter
    use({
      "nvim-treesitter/nvim-treesitter",
      commit = "58f61e56",
      run = ":TSUpdate",
    })

    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      commit = "13739a5",
      require = {
        "nvim-treesitter/nvim-treesitter",
      },
    })

    -- Telescope
    use({
      "nvim-telescope/telescope.nvim",
      commit = "4bd4205",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    })

    -- Notifications
    use({
      "rcarriga/nvim-notify",
      commit = "b005821",
      requires = {
        "nvim-lua/plenary.nvim",
      },
    })

    -- Git
    use({
      "lewis6991/gitsigns.nvim",
      commit = "d3a8ba0",
    })

    -- Java/Scala
    use({
      "mfussenegger/nvim-jdtls",
      commit = "7bc572f",
    })

    use({
      "scalameta/nvim-metals",
      commit = "613556d",
      requires = {
        "nvim-lua/plenary.nvim",
      },
    })

    -- Debugging
    use({
      "mfussenegger/nvim-dap",
      commit = "3d0d731",
    })

    use({
      "rcarriga/nvim-dap-ui",
      commit = "6a82715",
    })

    -- Colorhightling
    use({
      "norcalli/nvim-colorizer.lua",
      commit = "36c610a",
    })

    -- Testing
    use({
      "klen/nvim-test",
      commit = "32f162c",
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
      commit = "f45aecb",
      requires = {
        "lewis6991/gitsigns.nvim",
      },
    })

    -- Winsep
    use({
      "nvim-zh/colorful-winsep.nvim",
      commit = "bb06c86",
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
      commit = "38e090a",
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
      commit = "5ccce7b",
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

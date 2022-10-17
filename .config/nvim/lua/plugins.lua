local settings = require("settings")
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
      "wbthomason/packer.nvim", -- Have packer manage itself
      commit = "6afb674",
    })

    use({
      "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
      commit = "b7404d3",
    })

    use({
      "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
      commit = "9e7c628",
    })

    use({
      "windwp/nvim-autopairs",
      commit = "14cc2a4",
    })

    use({
      "windwp/nvim-ts-autotag",
      commit = "fdefe46",
    })

    use({
      "numToStr/Comment.nvim", -- Easily comment stuff
      commit = "d9cfae1",
    })

    use({
      "JoosepAlviste/nvim-ts-context-commentstring",
      commit = "4d3a68c",
      requires = {
        "nvim-treesitter/nvim-treesitter",
      },
    })

    use({
      "kyazdani42/nvim-web-devicons",
      commit = "563f363",
    })

    use({
      "kyazdani42/nvim-tree.lua",
      commit = "45d386a",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
    })

    use({
      "akinsho/bufferline.nvim",
      tag = "v2.11.*",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
    })

    use({
      "famiu/bufdelete.nvim",
      commit = "e88dbe0",
    })

    use({
      "nvim-lualine/lualine.nvim",
      commit = "a52f078",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
    })

    use({
      "akinsho/toggleterm.nvim",
      commit = "2a787c4",
    })

    use({
      "ahmedkhalf/project.nvim",
      commit = "628de7e",
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
      commit = "0b4f6e0",
    })

    use({
      "folke/tokyonight.nvim",
      commit = "23c0038",
    })

    -- cmp plugins
    use({
      "hrsh7th/nvim-cmp", -- The completion plugin
      commit = "2427d06",
    })

    use({
      "hrsh7th/cmp-buffer", -- buffer completions
      commit = "3022dbc",
    })

    use({
      "hrsh7th/cmp-path", -- path completions
      commit = "447c87c",
    })

    use({
      "hrsh7th/cmp-cmdline", -- cmdline completions
      commit = "c66c379",
    })

    use({
      "saadparwaiz1/cmp_luasnip", -- snippet completions
      commit = "a9de941",
    })

    use({
      "hrsh7th/cmp-nvim-lsp",
      commit = "affe808",
    })

    use({
      "hrsh7th/cmp-nvim-lua",
      commit = "d276254",
    })

    -- snippets
    use({
      "L3MON4D3/LuaSnip", --snippet engine
      commit = "8f8d493",
    })

    use({
      "rafamadriz/friendly-snippets", -- a bunch of snippets to use
      commit = "2be79d8",
    })

    -- Install Helper
    use({
      "williamboman/mason.nvim",
      commit = "a01073d",
    })

    use({
      "williamboman/mason-lspconfig.nvim",
      commit = "38ab1f3",
      requires = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
      },
    })

    use({
      "jayp0521/mason-null-ls.nvim",
      commit = "633d4ca",
      requires = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
      },
    })

    use({
      "jayp0521/mason-nvim-dap",
      commit = "240024e",
      requires = {
        "williamboman/mason.nvim",
        "mfussenegger/nvim-dap",
      },
    })

    -- LSP
    use({
      "neovim/nvim-lspconfig",
      commit = "af43c30",
    })

    use({
      "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
      commit = "c0c19f3",
    })

    use({
      "RRethy/vim-illuminate",
      commit = "a2e8476",
    })

    use({
      "SmiteshP/nvim-navic",
      commit = "132b273",
      requries = {
        "neovim/nvim-lspconfig",
      },
    })

    -- Treesitter
    use({
      "nvim-treesitter/nvim-treesitter",
      commit = "aebc6cf",
      run = ":TSUpdate",
    })

    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      commit = "80a38f9",
      require = {
        "nvim-treesitter/nvim-treesitter",
      },
    })

    -- Telescope
    use({
      "nvim-telescope/telescope.nvim",
      commit = "76ea9a8",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    })

    -- Notifications
    use({
      "rcarriga/nvim-notify",
      comment = "4144654",
      requires = {
        "nvim-lua/plenary.nvim",
      },
    })

    -- Git
    use({
      "lewis6991/gitsigns.nvim",
      commit = "f98c85e",
    })

    -- Java/Scala
    use({
      "mfussenegger/nvim-jdtls",
      commit = "75d27da",
    })

    use({
      "scalameta/nvim-metals",
      commit = "b7587a9",
      requires = {
        "nvim-lua/plenary.nvim",
      },
    })

    -- DAP
    use({
      "mfussenegger/nvim-dap",
      commit = "5d57c40",
    })

    use({
      "rcarriga/nvim-dap-ui",
      commit = "8d0768a",
    })

    --
    use({
      "norcalli/nvim-colorizer.lua",
      commit = "36c610a",
    })

    use({
      "klen/nvim-test",
      commit = "32f162c",
    })

    use({
      "nvim-neotest/neotest",
      commit = "272a22b",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        --"antoinemadec/FixCursorHold.nvim",
        --"Issafalcon/neotest-dotnet",
      },
    })

    use({
      "Issafalcon/neotest-dotnet",
      commit = "8198c57",
      requires = {
        --  "nvim-neotest/neotest",
      },
    })

    -- Folding
    use({
      "anuvyklack/pretty-fold.nvim",
      commit = "e6385d6",
    })

    use({
      "folke/which-key.nvim",
      disable = false,
      commit = "6885b66",
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

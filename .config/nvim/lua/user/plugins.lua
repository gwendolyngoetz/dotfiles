local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  use {
    "wbthomason/packer.nvim", -- Have packer manage itself
    commit = "6afb67460283f0e990d35d229fd38fdc04063e0a"
  }

  use {
    "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
    commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac"
  }

  use {
    "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
    commit = "9e7c62856e47053ec7b17f82c5da0f1e678d92c8"
  }

  use {
    "windwp/nvim-autopairs",
    commit = "14cc2a4fc6243152ba085cc2059834113496c60a"
  }

  use {
    "numToStr/Comment.nvim", -- Easily comment stuff
    commit = "d9cfae1059b62f7eacc09dba181efe4894e3b086"
  }

  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "4d3a68c41a53add8804f471fcc49bb398fe8de08",
    requires = {
        "nvim-treesitter/nvim-treesitter"
    }
  }

  use {
    "kyazdani42/nvim-web-devicons",
    commit = "563f3635c2d8a7be7933b9e547f7c178ba0d4352"
  }

  use {
    "kyazdani42/nvim-tree.lua",
    commit = "45d386a3591f87390390c0d718a81e05895465ca",
    requires = {
      "kyazdani42/nvim-web-devicons"
    }
  }

  use {
    "akinsho/bufferline.nvim",
    tag = "v2.11.*",
    requires = {
      "kyazdani42/nvim-web-devicons"
    }
  }

  use {
    "moll/vim-bbye",
    commit = "25ef93ac5a87526111f43e5110675032dbcacf56"
  }

  use {
    "nvim-lualine/lualine.nvim",
    commit = "a52f078026b27694d2290e34efa61a6e4a690621",
    requires = {
      "kyazdani42/nvim-web-devicons"
    }
  }

  use {
    "akinsho/toggleterm.nvim",
    commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda"
  }

  use {
    "ahmedkhalf/project.nvim",
    commit = "628de7e433dd503e782831fe150bb750e56e55d6"
  }

  use {
    "lewis6991/impatient.nvim",
    commit = "b842e16ecc1a700f62adb9802f8355b99b52a5a6"
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    tag = "v2.20.*"
  }

  use {
    "goolord/alpha-nvim",
    commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31"
  }

  -- Colorschemes
  use {
    "Mofiqul/dracula.nvim",
    commit = "0b4f6e009867027caddc1f28a81d8a7da6a2b277"
  }

  -- cmp plugins
  use {
    "hrsh7th/nvim-cmp", -- The completion plugin
    commit = "2427d06b6508489547cd30b6e86b1c75df363411"
  }

  use {
    "hrsh7th/cmp-buffer", -- buffer completions
    commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa"
  }

  use {
    "hrsh7th/cmp-path", -- path completions
    commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1"
  }

  use {
    "hrsh7th/cmp-cmdline", -- cmdline completions
    commit = "c66c379915d68fb52ad5ad1195cdd4265a95ef1e"
  }

  use {
    "saadparwaiz1/cmp_luasnip", -- snippet completions
    commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36"
  }

  use {
    "hrsh7th/cmp-nvim-lsp",
    commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8"
  }

  use {
    "hrsh7th/cmp-nvim-lua",
    commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21"
  }

  -- snippets
  use {
    "L3MON4D3/LuaSnip", --snippet engine
    commit = "8f8d493e7836f2697df878ef9c128337cbf2bb84"
  }

  use {
    "rafamadriz/friendly-snippets", -- a bunch of snippets to use
    commit = "2be79d8a9b03d4175ba6b3d14b082680de1b31b1"
  }

  -- Install Helper
  use {
    "williamboman/mason.nvim",
    commit = "a01073d9903ff25d9045b357d3d9fb63c4bc8e92"
  }

  use {
    "williamboman/mason-lspconfig.nvim",
    commit = "38ab1f3b5e6182118f53f069c526f1251b2a951f",
    requires = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig"
    }
  }

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    commit = "af43c300d4134db3550089cd4df6c257e3734689"
  }

  use {
    "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
    commit = "c0c19f32b614b3921e17886c541c13a72748d450"
  }

  use {
    "RRethy/vim-illuminate",
    commit = "a2e8476af3f3e993bb0d6477438aad3096512e42"
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    commit = "76ea9a898d3307244dce3573392dcf2cc38f340f",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    commit = "aebc6cf6bd4675ac86629f516d612ad5288f7868",
    run = ":TSUpdate",
  }

  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    commit = "f98c85e7c3d65a51f45863a34feb4849c82f240f"
  }

  -- Java/Scala
  use {
    "mfussenegger/nvim-jdtls",
    commit = "75d27daa061458dd5735b5eb5bbc48d3baad1186"
  }

  use {
    "scalameta/nvim-metals",
    commit = "b7587a9155d22761f1b28c18f7927e6df0d08387",
    requires = {
     "nvim-lua/plenary.nvim"
    }
  }

  -- DAP
  use {
    "mfussenegger/nvim-dap",
    commit = "5d57c401cab25997a6d8202b2498ad5ac895f143"
  }

  use {
    "rcarriga/nvim-dap-ui",
    commit = "8d0768a83f7b89bd8cb8811800bc121b9353f0b2"
  }

  use {
    "ravenxrz/DAPInstall.nvim",
    commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de"
  }

  use {
    "norcalli/nvim-colorizer.lua",
    commit = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6"
  }

  use {
    "klen/nvim-test",
    commit = "32f162c27045fc712664b9ddbd33d3c550cb2bfc"
  }

  ---- Folding
  --use {
  --  "anuvyklack/pretty-fold.nvim",
  --  commit = "e6385d62eec67fdc8a21700b42a701d0d6fb8b32"
  --}

  use {
    "folke/which-key.nvim",
    commit = "6885b669523ff4238de99a7c653d47b081b5506d"
  }



  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

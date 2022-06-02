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
    commit = "4dedd3b08f8c6e3f84afbce0c23b66320cd2a8f2"
  }

  use {
    "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
    commit = "b7404d35d5d3548a82149238289fa71f7f6de4ac"
  }

  use {
    "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
    commit = "1da13add868968802157a0234136d5b1fbc34dfe"
  }

  use {
    "windwp/nvim-autopairs",
    commit = "b9cc0a26f3b5610ce772004e1efd452b10b36bc9"
  }

  use {
    "kyazdani42/nvim-web-devicons",
    commit = "d096ee903e04019ec8b4dff66a888189b3b99e44"
  }

  use {
    "kyazdani42/nvim-tree.lua",
    commit = "b1ecb75a6cf0bc83ec64d987c7f4128ada3c254e",
    requires = {
      "kyazdani42/nvim-web-devicons"
    }
  }

  use {
    "akinsho/bufferline.nvim",
    tag = "v2.2.*",
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
    commit = "3362b28f917acc37538b1047f187ff1b5645ecdd",
    requires = {
      "kyazdani42/nvim-web-devicons"
    }
  }

  use {
    "lewis6991/impatient.nvim",
    commit = "bcc22509bdf1c9d9e63e5e44ad00f5fcf581d651"
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    tag = "v2.18.*"
  }

  use {
    "antoinemadec/FixCursorHold.nvim", -- This is needed to fix lsp doc highlight
    commit = "1bfb32e7ba1344925ad815cb0d7f901dbc0ff7c1"
  }

  -- Colorschemes
  use {
    "dracula/vim",
    commit = "d7723a842a6cfa2f62cf85530ab66eb418521dc2"
  }

  -- cmp plugins
  use {
    "hrsh7th/nvim-cmp", -- The completion plugin
    commit = "033a817ced907c8bcdcbe3355d7ea67446264f4b"
  }

  use {
    "hrsh7th/cmp-buffer", -- buffer completions
    commit = "12463cfcd9b14052f9effccbf1d84caa7a2d57f0"
  }

  use {
    "hrsh7th/cmp-path", -- path completions
    commit = "466b6b8270f7ba89abd59f402c73f63c7331ff6e"
  }

  use {
    "hrsh7th/cmp-cmdline", -- cmdline completions
    commit = "c36ca4bc1dedb12b4ba6546b96c43896fd6e7252"
  }

  use {
    "saadparwaiz1/cmp_luasnip", -- snippet completions
    commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36"
  }

  use {
    "hrsh7th/cmp-nvim-lsp",
    commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8"
  }

  -- -- snippets
  use {
    "L3MON4D3/LuaSnip", --snippet engine
    commit = "52f4aed58db32a3a03211d31d2b12c0495c45580"
  }

  use {
    "rafamadriz/friendly-snippets", -- a bunch of snippets to use
    commit = "974d79269a5a7f63e973db6a51b081a45750d026"
  }

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    commit = "b86a37caf7a4e53e62ba883aef5889b590260de9"
  }

  use {
    "williamboman/nvim-lsp-installer", -- simple to use language server installer
    commit = "b210fffba39e56f1615e9283ad7e2b41ed1a5064",
    requires = {
      "neovim/nvim-lspconfig"
    }
  }

  use {
    "tamago324/nlsp-settings.nvim", -- language server settings defined in json for
    commit = "dadedae362f20c0a874290241c2aae21ad3e86db",
    requires = {
      "neovim/nvim-lspconfig"
    }
  }

  use {
    "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
    commit = "5ef0680d66d4fbebdcc8bed8cabe056470c802ff"
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    commit = "09e73bc72d30ac09ea5300ce6a95c945e96db901",
    run = ":TSUpdate",
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    commit = "54be102e20ee4acaaa17e9fce8be07fb586630df",
    requries = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  }

  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "88343753dbe81c227a1c1fd2c8d764afb8d36269",
    requires = {
        "nvim-treesitter/nvim-treesitter"
    }
  }

  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    commit = "27aeb2e715c32cbb99aa0b326b31739464b61644"
  }

  use {
    "christianchiarulli/nvim-gps",
    branch = "text_hl",
    commit = "b8e8b386dcc003453968df65047518c1b761e637"
  }

  use {
    "mfussenegger/nvim-dap",
    commit = "0062c19424ac751f47227b440c3d6c7e584687ff"
  }

  use {
    "scalameta/nvim-metals",
    commit = "9f8272802d35928df6c739f8e06f0e2767ad53a7",
    requires = {
      "nvim-lua/plenary.nvim"
    }
  }

  -- Folding
  --use {
  --  "anuvyklack/pretty-fold.nvim",
  --  commit = "e6385d62eec67fdc8a21700b42a701d0d6fb8b32"
  --}

  -- use "folke/which-key.nvim"
  -- use "akinsho/toggleterm.nvim"
  -- use "ahmedkhalf/project.nvim"
  -- use "goolord/alpha-nvim"
  -- use "numToStr/Comment.nvim" -- Easily comment stuff



  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

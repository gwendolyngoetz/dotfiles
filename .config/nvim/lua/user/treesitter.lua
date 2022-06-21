local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ensure_installed = {
    "bash",
    "c_sharp",
    "cmake",
    "css",
    "go",
    "html",
    "java",
    "json",
    "lua",
    "markdown",
    "scala",
    "yaml"
  },
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "css" }, -- list of language that will be disabled
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "python", "css" } },
}

--vim.cmd "set foldmethod=expr"
--vim.cmd "set foldexpr=nvim_treesitter#foldexpr()"

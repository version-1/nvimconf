require 'colorizer'.setup()
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "ruby",
    "go",
    "zig",
    "tsx",
    "javascript",
    "typescript",
    "json",
    "yaml",
    "html",
    "css",
    "lua",
    "vim",
    "markdown",
    "sql",
    "yaml"
  },
  auto_install = true,
  highlight = {
    enable = true,
  },
}
goimports = 1


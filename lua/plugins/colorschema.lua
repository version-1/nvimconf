return {
  -- "shaunsingh/nord.nvim",
    "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    vim.cmd([[colorscheme tokyonight-storm]])
  end,
}

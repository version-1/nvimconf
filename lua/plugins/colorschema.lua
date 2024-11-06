return {
  "shaunsingh/nord.nvim",
  -- "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- require("tokyonight").setup {
    --   transparent = true,
    --   styles = {
    --     sidebars = "transparent",
    --     floats = "transparent",
    --   }
    -- }
    -- vim.cmd([[colorscheme tokyonight-storm]])
    vim.g.nord_disable_background = true
    vim.cmd([[colorscheme nord]])
  end,
}

return {
  -- {
  --   "shaunsingh/nord.nvim",
  --   lazy = false,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- vim.g.nord_disable_background = true
  --     vim.cmd([[colorscheme nord]])
  --   end
  -- },
  -- {
  --   -- "nyoom-engineering/oxocarbon.nvim",
  --   "version-1/oxocarbon.nvim",
  --   lazy = true,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     vim.opt.background = "dark"
  --     vim.cmd([[colorscheme oxocarbon]])
  --     -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --     -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --     -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  --   end
  -- },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup {
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        on_highlights = function(hl, c)
          hl.TelescopeNormal       = {
            bg = c.bg_dark,
            fg = c.fg_dark,
          }
          hl.TelescopePromptNormal = {
            bg = c.bg_dark,
          }
          hl.TelescopeBorder       = {
            bg = c.bg_dark,
          }
          hl.TelescopePromptBorder = {
            bg = c.bg_dark,
          }
          hl.TelescopePromptTitle  = {
            bg = c.bg_dark,
            fg = c.fg_dark,
          }
          hl.TelescopePreviewTitle = {
            bg = c.bg_dark,
            fg = c.fg_dark,
          }
          hl.TelescopeResultsTitle = {
            bg = c.bg_dark,
            fg = c.fg_dark,
          }
          hl.WhichKeyNormal        = {
            bg = c.bg_dark
          }
          hl.LazyNormal            = {
            bg = c.bg_dark,
            fg = c.fg_dark,
          }
        end,
      }
      vim.cmd([[colorscheme tokyonight-storm]])
    end
  },
}

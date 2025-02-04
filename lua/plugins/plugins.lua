return {
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    config = function()
      require('nvim-web-devicons').setup({
        default = true,
        color_icons = true,
      })
    end
  },
  {
    "github/copilot.vim",
  },
  {
    "simeji/winresizer",
  },
  -- FIXME: wanna get plugins which preview doesnt overwrap on color code
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("ibl").setup()
    end,
  },
  {'akinsho/git-conflict.nvim', version = "*", config = true}
  -- {
  --   "kylechui/nvim-surround",
  --   version = "*", -- Use for stability; omit to use `main` branch for the latest features
  --   event = "VeryLazy",
  --   config = function()
  --     require("nvim-surround").setup({
  --       -- Configuration here, or leave empty to use defaults
  --     })
  --   end
  -- },
}

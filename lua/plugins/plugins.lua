
return {
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        default = true;
        color_icons = true;
      })
    end
  },
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Telescope find_files" },
      { "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Telescope find_files" },
    },
    dependencies = { 'nvim-lua/plenary.nvim' }
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
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
}


return {
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
    "scrooloose/nerdtree",
    keys = {
      { "<leader>e", "<cmd>NERDTreeToggle<cr>", desc = "NERDTreeToggle" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
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
    "hrsh7th/nvim-cmp",
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
    },
  },
  {
    "mhartington/formatter.nvim",
    keys = {
      { "<leader>i", "<cmd>Format<cr>", desc = "Format" },
      { "<leader>F", "<cmd>FormatWrite<cr>", desc = "Format" },
    },
  },
  {
    "github/copilot.vim",
  },
  {
    "simeji/winresizer",
  },
  {
    "tomtom/tcomment_vim"
  },
  {
    "github/copilot.vim"
  },
	{
    "norcalli/nvim-colorizer.lua",
	},
	{
    'vim-syntastic/syntastic'
	},
	{
		'nathanaelkane/vim-indent-guides'
	},
	{
    'tpope/vim-surround',
	},
  -- languages
  {
    "ngmy/vim-rubocop"
  },
  {
    "mattn/vim-goimports"
  },
  {
    "fatih/vim-go"
  },
}

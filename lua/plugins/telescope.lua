return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  priority = 10000,
  keys = {
    { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Telescope find_files" },
    { "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Telescope live_greps" },
    { "<leader>r", "<cmd>Telescope resume<cr>", desc = "Telescope Resume" },
    { "<leader>b", "<cmd>Telescope pickers<cr>", desc = "Telescope Previous Picker" },
    { "<leader>f", "<cmd>Telescope quickfix<cr>", desc = "Telescope Quixfix" },
    { "<leader>H", "<cmd>Telescope help_tugs<cr>", desc = "Telescope Help Tags" },
  },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    pickers = {
      colorscheme = {
        enable_preview = true,
      }
    }
  }
}

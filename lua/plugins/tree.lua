return {
  "nvim-tree/nvim-tree.lua",
  event = "VeryLazy",
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Telescope find_files" },
  },
  config = function()
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
      },
    })
  end
}

return {
  "nvim-tree/nvim-tree.lua",
  event = "VeryLazy",
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "TreeToggle" },
  },
  config = function()
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
      },
    })
    local api = vim.api
    local opts = function(desc)
      return { desc = "nvim-tree: " .. desc, noremap = true, silent = true, nowait = true }
    end
    vim.keymap.set("n", "<CR>", api.node.open.no_window_picker, opts "Open: No Window Picker")
    vim.keymap.set("n", "O", api.node.open.edit, opts "Open: No Window Picker")
  end
}
